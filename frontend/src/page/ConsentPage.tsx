import {Checkbox} from '@/components/ui/checkbox'
import {
    Field,
    FieldContent,
    FieldDescription,
    FieldGroup,
    FieldLabel,
    FieldLegend,
    FieldSeparator,
    FieldSet,
} from '@/components/ui/field'

import {Accordion, AccordionContent, AccordionItem, AccordionTrigger,} from '@/components/ui/accordion'
import {Button} from '@/components/ui/button.tsx';
import {useNavigate} from 'react-router-dom'

export const ConsentPage = () => {

    const navigator = useNavigate();

    const handleClick = () => {
        navigator('/questionnaire')
    }
    return (
        <>
            <Accordion
                type="single"
                collapsible
                className="w-full"
                defaultValue="item-1"
            >
                <AccordionItem value="item-1">
                    <AccordionTrigger>Product Information</AccordionTrigger>
                    <AccordionContent className="flex flex-col gap-4 text-balance">
                        <p>
                            Our flagship product combines cutting-edge technology with sleek
                            design. Built with premium materials, it offers unparalleled
                            performance and reliability.
                        </p>
                        <p>
                            Key features include advanced processing capabilities, and an
                            intuitive user interface designed for both beginners and experts.
                        </p>
                    </AccordionContent>
                </AccordionItem>
                <AccordionItem value="item-2">
                    <AccordionTrigger>Shipping Details</AccordionTrigger>
                    <AccordionContent className="flex flex-col gap-4 text-balance">
                        <p>
                            We offer worldwide shipping through trusted courier partners.
                            Standard delivery takes 3-5 business days, while express shipping
                            ensures delivery within 1-2 business days.
                        </p>
                        <p>
                            All orders are carefully packaged and fully insured. Track your
                            shipment in real-time through our dedicated tracking portal.
                        </p>
                    </AccordionContent>
                </AccordionItem>
                <AccordionItem value="item-3">
                    <AccordionTrigger>Return Policy</AccordionTrigger>
                    <AccordionContent className="flex flex-col gap-4 text-balance">
                        <p>
                            We stand behind our products with a comprehensive 30-day return
                            policy. If you&apos;re not completely satisfied, simply return the
                            item in its original condition.
                        </p>
                        <p>
                            Our hassle-free return process includes free return shipping and
                            full refunds processed within 48 hours of receiving the returned
                            item.
                        </p>
                    </AccordionContent>
                </AccordionItem>
            </Accordion>
            <div className="w-full max-w-md">
                <FieldGroup>
                    <FieldSet>
                        <FieldLegend variant="label">
                            Show these items on the desktop
                        </FieldLegend>
                        <FieldDescription>
                            Select the items you want to show on the desktop.
                        </FieldDescription>
                        <FieldGroup className="gap-3">
                            <Field orientation="horizontal">
                                <Checkbox id="finder-pref-9k2-hard-disks-ljj"/>
                                <FieldLabel
                                    htmlFor="finder-pref-9k2-hard-disks-ljj"
                                    className="font-normal"
                                    defaultChecked
                                >
                                    Hard disks
                                </FieldLabel>
                            </Field>
                            <Field orientation="horizontal">
                                <Checkbox id="finder-pref-9k2-external-disks-1yg"/>
                                <FieldLabel
                                    htmlFor="finder-pref-9k2-external-disks-1yg"
                                    className="font-normal"
                                >
                                    External disks
                                </FieldLabel>
                            </Field>
                            <Field orientation="horizontal">
                                <Checkbox id="finder-pref-9k2-cds-dvds-fzt"/>
                                <FieldLabel
                                    htmlFor="finder-pref-9k2-cds-dvds-fzt"
                                    className="font-normal"
                                >
                                    CDs, DVDs, and iPods
                                </FieldLabel>
                            </Field>
                            <Field orientation="horizontal">
                                <Checkbox id="finder-pref-9k2-connected-servers-6l2"/>
                                <FieldLabel
                                    htmlFor="finder-pref-9k2-connected-servers-6l2"
                                    className="font-normal"
                                >
                                    Connected servers
                                </FieldLabel>
                            </Field>
                        </FieldGroup>
                    </FieldSet>
                    <FieldSeparator/>
                    <Field orientation="horizontal">
                        <Checkbox id="finder-pref-9k2-sync-folders-nep" defaultChecked/>
                        <FieldContent>
                            <FieldLabel htmlFor="finder-pref-9k2-sync-folders-nep">
                                全部OK?
                            </FieldLabel>
                            <FieldDescription>
                                同意する場合はチェックを入れてください。
                            </FieldDescription>
                        </FieldContent>
                    </Field>
                </FieldGroup>
            </div>
            <Button variant="outline" onClick={handleClick}>次へ</Button>
        </>
    )
}
