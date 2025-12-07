import {DynamoDBClient} from '@aws-sdk/client-dynamodb';
import {DynamoDBDocumentClient, QueryCommand, QueryCommandInput} from '@aws-sdk/lib-dynamodb';

type QuestionnaireEntity = {
    pk: string
    sk: string
    entityType: string
    gender: string
    toeicScore: number
    group: string
    startedAt: string
}

export const handler = async () => {
    const baseClient = new DynamoDBClient({
        region: 'ap-northeast-1',
        endpoint: process.env.DYNAMODB_ENDPOINT || 'http://localstack:4566'
    });
    const client = DynamoDBDocumentClient.from(baseClient)
    const table = process.env.DYNAMODB_TABLE || 'dev-research-form-progress';

    const queryDdbByGsiPk = async <T>(index: string, gsiPk: string):Promise<T[]> => {
        //DynamoDB Query が返す 「次のページの開始点」 を格納する変数。
        let ExclusiveStartKey: QueryCommandInput['ExclusiveStartKey']
        // Query 結果を 全部まとめて格納する配列。
        const items:T[] = []
        //exprAttrValues は KeyConditionExpression の中で使うプレースホルダ（:m）に実際の値を割り当てる辞書です。
        // DynamoDB の Query は直接 "MEDIA" と書けないため、必ず :m のような変数に置き換えて値を渡します。
        const exprAttrValues: QueryCommandInput['ExpressionAttributeValues'] = {
            ':m': gsiPk
        }
        do {
            const queryInput: QueryCommandInput = {
                TableName: table,                   // どのテーブルを検索するか
                IndexName: index,                   // どのGSIを使うか
                KeyConditionExpression: 'entityType = :m', // GSIのPK検索条件
                ExpressionAttributeValues: exprAttrValues, // :m に実際の値を代入
                ExclusiveStartKey                  // 次ページの開始位置（最初は undefined）
            }

            const command = new QueryCommand(queryInput)

            const response = await client.send(command)
            if (response.Items) {
                items.push(...(response.Items as any[]))
            }
            if (
                response.LastEvaluatedKey &&
                typeof (response.LastEvaluatedKey).pk === 'string' &&
                typeof (response.LastEvaluatedKey).sk === 'string'
            ) {
                ExclusiveStartKey = {
                    pk: response.LastEvaluatedKey.pk,
                    sk: response.LastEvaluatedKey.sk
                }
            } else {
                ExclusiveStartKey = undefined
            }
        }
        while (ExclusiveStartKey)

        return items
    }

    const getAllQuestionnaires = async (): Promise<QuestionnaireEntity[]> => {
        return await queryDdbByGsiPk<QuestionnaireEntity>('GSI_Questionnaire', 'QUESTIONNAIRE')
    }

    try {
        const questionnairesItem = await getAllQuestionnaires()
        const questionnaires = questionnairesItem.map((item) => ({
            pk: item.pk,
            sk: item.sk,
            gender: item.gender,
            toeicScore: item.toeicScore,
            group: item.group,
            startedAt: item.startedAt
        }))

        return {statusCode: 200, body: JSON.stringify(questionnaires)}
    } catch (error) {
        console.error('error', error)
        return {statusCode: 500}
    }
}