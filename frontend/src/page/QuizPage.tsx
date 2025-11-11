import { Kbd, KbdGroup } from "@/components/ui/kbd"

export function QuizPage() {
    return (
        <div className="flex flex-col items-center gap-4">
            <KbdGroup>
                <Kbd>h</Kbd>
                <span>or</span>
                <Kbd>j</Kbd>
            </KbdGroup>
        </div>
    )
}

