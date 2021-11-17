# https://github.com/pester/Pester
# https://blog.danskingdom.com/A-better-way-to-do-TestCases-when-unit-testing-with-Pester/
# https://sqldbawithabeard.com/2017/07/06/writing-dynamic-and-random-tests-cases-for-pester/

$TestCases =@(
    @{ ComputerName = "DC01" }
    @{ ComputerName = "SQL01" }
    @{ ComputerName = "WEB01" }
)

Describe "Hyper-V" {
    Context "State" {
        It "<ComputerName>" -TestCases $TestCases {
            param (
                $ComputerName
            )
            (Get-VM -Name $ComputerName).State | Should -Be "Running"
        }
    }
}

Describe "Networking" {
    Context "Ping" {
        It "<ComputerName>" -TestCases $TestCases {
            param (
                $ComputerName
            )
            (Test-NetConnection -ComputerName $ComputerName -WarningAction SilentlyContinue).PingSucceeded | Should -BeTrue
        }
    }
}
