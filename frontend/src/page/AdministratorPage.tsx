import {
    Table,
    TableBody,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table'

const invoices = [
    {
        invoice: 'INV001',
        paymentStatus: 'Paid',
        // totalAmount: "$250.00",
        paymentMethod: 'Credit Card',
    },
    {
        invoice: 'INV002',
        paymentStatus: 'Pending',
        // totalAmount: "$150.00",
        paymentMethod: 'PayPal',
    },
    {
        invoice: 'INV003',
        paymentStatus: 'Unpaid',
        // totalAmount: "$350.00",
        paymentMethod: 'Bank Transfer',
    },
    {
        invoice: 'INV004',
        paymentStatus: 'Paid',
        // totalAmount: "$450.00",
        paymentMethod: 'Credit Card',
    },
    {
        invoice: 'INV005',
        paymentStatus: 'Paid',
        // totalAmount: "$550.00",
        paymentMethod: 'PayPal',
    },
    {
        invoice: 'INV006',
        paymentStatus: 'Pending',
        // totalAmount: "$200.00",
        paymentMethod: 'Bank Transfer',
    },
    {
        invoice: 'INV007',
        paymentStatus: 'Unpaid',
        // totalAmount: "$300.00",
        paymentMethod: 'Credit Card',
    },
]

const invoices1 = [
    {
        invoice: 'INV001',
        paymentStatus: '1',
        totalAmount: '250',
        paymentMethod: '正解',
    },
    {
        invoice: 'INV001',
        paymentStatus: '2',
        totalAmount: '350',
        paymentMethod: '正解',
    },
    {
        invoice: 'INV001',
        paymentStatus: '3',
        totalAmount: '350',
        paymentMethod: '正解',
    },
    {
        invoice: 'INV001',
        paymentStatus: '4',
        totalAmount: '450',
        paymentMethod: '不正解',
    },
    {
        invoice: 'INV001',
        paymentStatus: '5',
        totalAmount: '550',
        paymentMethod: '不正解',
    },
    {
        invoice: 'INV002',
        paymentStatus: '1',
        totalAmount: '250',
        paymentMethod: '正解',
    },
    {
        invoice: 'INV001',
        paymentStatus: '2',
        totalAmount: '1250',
        paymentMethod: '正解',
    },
]

export function AdministratorPage() {
    return (
        <>
            <a>アンケート結果</a>
            <Table className="border border-black mb-10 w-[300px]">
                {/*<TableCaption>A list of your recent invoices.</TableCaption>*/}
                <TableHeader>
                    <TableRow>
                        <TableHead className="w-[90px]">学籍番号</TableHead>
                        <TableHead className="w-[90px]">TOEIC</TableHead>
                        <TableHead>性別</TableHead>
                        {/*<TableHead className="text-right">Amount</TableHead>*/}
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {invoices.map((invoice) => (
                        <TableRow key={invoice.invoice}>
                            <TableCell className="font-medium">{invoice.invoice}</TableCell>
                            <TableCell>{invoice.paymentStatus}</TableCell>
                            <TableCell>{invoice.paymentMethod}</TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
            <a>弁別テスト結果</a>
            <Table className="border border-black mb-10 w-[600px]">
                {/*<TableCaption>A list of your recent invoices.</TableCaption>*/}
                <TableHeader>
                    <TableRow>
                        <TableHead className="w-[100px]">学籍番号</TableHead>
                        <TableHead>問題番号</TableHead>
                        <TableHead>回答</TableHead>
                        <TableHead className="text-right">反応速度(ms)</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {invoices1.map((invoice) => (
                        <TableRow key={invoice.invoice}>
                            <TableCell className="font-medium">{invoice.invoice}</TableCell>
                            <TableCell>{invoice.paymentStatus}</TableCell>
                            <TableCell>{invoice.paymentMethod}</TableCell>
                            <TableCell className="text-right">{invoice.totalAmount}</TableCell>
                        </TableRow>
                    ))}
                </TableBody>
                <TableFooter>
                    <TableRow>
                        <TableCell colSpan={3}>平均</TableCell>
                        <TableCell className="text-right">500</TableCell>
                    </TableRow>
                </TableFooter>
            </Table>
        </>
    )
}
