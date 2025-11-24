import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger
} from '@/components/ui/alert-dialog.tsx';
import {Select, SelectContent, SelectGroup, SelectItem, SelectTrigger, SelectValue,} from '@/components/ui/select'
import {InputOTP, InputOTPGroup, InputOTPSlot} from '@/components/ui/input-otp'
import {Button} from '@/components/ui/button.tsx';
import {useState} from 'react';
import axios from 'axios';
import {useNavigate} from 'react-router-dom';
import {Label} from '@radix-ui/react-label';

export const QuestionnairePage = () => {
    // const [open, setOpen] = useState(false)
    const [gender, setGender] = useState('')
    const [studentNumber, setStudentNumber] = useState('');
    const [toeicScore, setToeicScore] = useState('');
    const [group, setGroup] = useState('')
    const navigator = useNavigate();

    const handleClick = async () => {
        try {
            console.log(studentNumber, toeicScore, gender, new Date().toISOString())
            console.log(typeof group)
            const postQuestionnairesRes = await axios.post('http://localhost:3000/questionnaires', {
                studentNumber,
                gender,
                toeicScore,
                group,
                startedAt: new Date().toISOString()
            })
            if (postQuestionnairesRes.status === 201) {
                navigator('/quiz')
            } else {
                alert('エラーが発生しました。時間を空けてもう一度お試しください。')
            }
        } catch (e) {
            console.log(e)
        }
    }
    return <>
        <div className="flex flex-col  w-full h-screen justify-center items-center gap-8">
            <div className="flex flex-col items-start gap-8">
                <Label>
                    学籍番号を入力してください。
                    <InputOTP
                        maxLength={6}
                        value={studentNumber}
                        onChange={(value) => setStudentNumber(value)}
                    >
                        <InputOTPGroup>
                            <InputOTPSlot index={0}/>
                            <InputOTPSlot index={1}/>
                            <InputOTPSlot index={2}/>
                            <InputOTPSlot index={3}/>
                            <InputOTPSlot index={4}/>
                            <InputOTPSlot index={5}/>
                        </InputOTPGroup>
                    </InputOTP>
                    <div className="text-center text-sm">
                        {studentNumber === '' ? (
                            <></>
                        ) : (
                            <></>
                        )}
                    </div>
                </Label>

                <Label>
                    参加者の性別を選択してください。
                    <Select onValueChange={(value) => setGender(value)} value={gender}>
                        <SelectTrigger className="w-[180px]">
                            <SelectValue placeholder=""/>
                        </SelectTrigger>
                        <SelectContent>
                            <SelectGroup>
                                <SelectItem value="男性">男性</SelectItem>
                                <SelectItem value="女性">女性</SelectItem>
                            </SelectGroup>
                        </SelectContent>
                    </Select>
                </Label>


                <Label>
                    TOEICスコアを入力してください。
                    <InputOTP
                        maxLength={3}
                        value={toeicScore}
                        onChange={(value) => setToeicScore(value)}
                    >
                        <InputOTPGroup>
                            <InputOTPSlot index={0}/>
                            <InputOTPSlot index={1}/>
                            <InputOTPSlot index={2}/>
                        </InputOTPGroup>
                    </InputOTP>
                    <div className="text-center text-sm">
                        {toeicScore === '' ? (
                            <></>
                        ) : (
                            <></>
                        )}
                    </div>
                </Label>

                <Label>
                    グループを選択してください。
                    <Select onValueChange={(value) => setGroup(value)} value={group}>
                        <SelectTrigger className="w-[180px]">
                            <SelectValue placeholder=""/>
                        </SelectTrigger>
                        <SelectContent>
                            <SelectGroup>
                                <SelectItem value="groupA">groupA</SelectItem>
                                <SelectItem value="groupB">groupB </SelectItem>
                                <SelectItem value="groupC">groupC </SelectItem>
                                <SelectItem value="groupD">groupD </SelectItem>
                                <SelectItem value="groupE">groupE </SelectItem>
                            </SelectGroup>
                        </SelectContent>
                    </Select>
                </Label>

            </div>


            <AlertDialog>
                <AlertDialogTrigger asChild>
                    <Button variant="outline">完了</Button>
                </AlertDialogTrigger>
                <AlertDialogContent>
                    <AlertDialogHeader>
                        <AlertDialogTitle>準備は完了していますか？</AlertDialogTitle>
                        <AlertDialogDescription>
                            次へボタンを押すと弁別テストの練習が開始されます。
                            準備の上、次へボタンを教えてください。

                            事前にイヤホン、キーボード、静かな環境を用意してください。
                        </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                        <AlertDialogCancel>戻る</AlertDialogCancel>
                        <AlertDialogAction onClick={handleClick}>次へ</AlertDialogAction>
                    </AlertDialogFooter>
                </AlertDialogContent>
            </AlertDialog>
        </div>
    </>

}
