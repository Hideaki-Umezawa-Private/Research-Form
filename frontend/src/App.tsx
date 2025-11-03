import {useAsync} from 'react-use'
import axios from 'axios'
import {useState} from 'react'

export const App = () => {
    const [getHelloWorld, setGetHelloWorld] = useState<string>('');
    useAsync(async () => {
        const res = await axios.get('http://localhost:3000/hello-world')
        setGetHelloWorld(res.data.message)
    }, [])

    return (
        <>
            <div className="grid grid-cols-5 gap-4 p-4">
                <div className="bg-neutral-500 text-white p-2 rounded">Neutral</div>
                <div className="bg-gray-500 text-white p-2 rounded">Gray</div>
                <div className="bg-zinc-500 text-white p-2 rounded">Zinc</div>
                <div className="bg-stone-500 text-white p-2 rounded">Stone</div>
                <div className="bg-slate-500 text-white p-2 rounded">Slate</div>
            </div>
            <div>{getHelloWorld}</div>
        </>
    )
}