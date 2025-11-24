import { Route, Routes } from 'react-router-dom'
import {NotFoundPage} from '@/page/NotFoundPage.tsx';
import {QuizPage} from '@/page/QuizPage.tsx';
import {ConsentPage} from '@/page/ConsentPage.tsx';
import {QuestionnairePage} from '@/page/QuestionnairePage.tsx';
import {ThanksPage} from '@/page/ThanksPage.tsx';
import {AdministratorPage} from '@/page/AdministratorPage.tsx';
import {HelloWorld} from '@/page/HelloWorld.tsx';

export const App = () => {
    return (
        <>
            <Routes>
                <Route path="/" element={<ConsentPage />} />
                <Route path="/questionnaire" element={<QuestionnairePage />} />
                <Route path="/quiz" element={<QuizPage />} />
                <Route path="/thanks" element={<ThanksPage />} />
                <Route path="/administrator" element={<AdministratorPage />} />
                <Route path="/hello-world" element={<HelloWorld />} />
                <Route path="*" element={<NotFoundPage />} />
            </Routes>
        </>
    )
}