// ===============================
// Lambda関数ビルドスクリプト
// ===============================
// 複数のLambda関数（main/*/src/handler.ts）を自動で探し出して、
// Node.js用に最適化された形式でdist/index.jsとしてビルドします。

// Node.js用に最適化された超高速ビルドツール（TypeScript→JavaScript変換も担当）
import { build } from 'esbuild'
// パターンでファイル検索するツール（複数Lambdaを自動検出）
import { globby } from 'globby'
// パス操作・URL操作・ファイル操作（Node.js標準）
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { mkdir, rm } from 'node:fs/promises'

// __dirname の代替（ESMでは自動で使えないため）URL形式 → 通常のファイルパス形式 に変換する
const __dirname = dirname(fileURLToPath(import.meta.url))

//  ../main/*/src/handler.ts を探す
const entries = await globby(['../main/*/src/handler.ts'], { cwd: __dirname, absolute: true })

// Lambda関数が1つも見つからなかったら終了
if (entries.length === 0) {
    console.log('No lambda entries found')
    process.exit(0)
}

console.log(`Found ${entries.length} lambda entries`)
console.log({ entries })
console.log('Building lambdas...')

// import "@/..." のようなパスを解決する簡易プラグイン
// （@をlambdaプロジェクトのルートに対応させる）
const aliasPlugin = {
    name: 'alias-plugin',
    setup(build) {
        const { onResolve } = build
        // import "@/utils/xxx" → 実際のパスに変換
        onResolve({ filter: /^@\/(.*)/ }, (args) => {
            const rel = args.path.replace(/^@\//, '')
            return { path: join(__dirname, '..', rel) }
        })
        // import "@" → ルートを直接参照
        onResolve({ filter: /^@$/ }, (args) => ({ path: join(__dirname, '..') }))
    }
}

//見つかったすべてのLambda関数を1個ずつビルドしてdist/index.jsを吐き出す
for (const entry of entries) {
    //entry = "/project/lambda/main/helloWorld/src/handler.ts"
    //fnDir = "/project/lambda/main/helloWorld"
    //entry から末尾の /src/handler.ts を取り除いて、親ディレクトリを取り出してる。
    const fnDir = entry.split('/src/handler.ts')[0]
    //distディレクトリのパスを決める
    const outdir = join(fnDir, 'dist')
    // 既存のdistディレクトリを削除してから新規作成,
    // rm(...)：過去の dist を削除
    await rm(outdir, { recursive: true, force: true }).catch(() => {})
    // mkdir(...)：新しい 空のdist ディレクトリを作成
    await mkdir(outdir, { recursive: true })

  console.log(`Building: ${entry} -> ${outdir}/index.js`);
  await build({
    //このhandler.tsを起点に、使ってる依存ファイルも全部取り込む
    entryPoints: [entry],
    //依存ファイルを1ファイルにまとめる
    bundle: true,
    //Node.js向けに最適化する。ブラウザじゃなくサーバー用コードとして扱う
    platform: "node",
    //	Node.js v20 で動く構文にしてね、という指定
    target: ["node20"],
    //出力形式はCommonJS形式で
    format: "cjs",
    //出力ファイルのパス
    outfile: join(outdir, "index.js"),
    //ソースマップは不要
    sourcemap: false,
    //コードを圧縮してサイズを小さくする
    minify: true,
    //sharp のような一部ライブラリはバンドルしないで外部扱いにする、という指定
    external: ["sharp"],
    // package.json の module/main フィールドを優先的に使う
    mainFields: ["module", "main"],
    // Node.js用の条件付きエクスポートを優先的に使う
    conditions: ["node", "default"],
    // 先ほど定義したパスエイリアスプラグインを使う
    plugins: [aliasPlugin],
  });
}

console.log('All lambdas built.')
