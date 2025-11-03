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
            <h1>Tailwind Ready!</h1>
            <h1 className="text-3xl font-bold text-red-500"> Tailwind Ready! </h1>
            <div>{getHelloWorld}</div>
        </>
    )
}