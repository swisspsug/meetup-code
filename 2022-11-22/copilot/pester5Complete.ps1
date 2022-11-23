# user pester 5 syntax to test all the functions in basicFunctionComplete.ps1
# load script beforeall and make sure nothing is returned
BeforeAll {
    . $PSScriptRoot\basicFunctionComplete.ps1
}
# test addTwoNumbers function
Describe "addTwoNumbers" {
    It "should add two numbers" {
        addTwoNumbers -num1 5 -num2 10 | Should -Be 15
    }
}
# test addArrayNumbers function
Describe "addArrayNumbers" {
    It "should add an array of numbers" {
        addArrayNumbers -numArray @(1,2,3,4,5) | Should -Be 15
    }
}
# test generateNames function
Describe "generateNames" {
    It "should generate a name" {
        generateNames | Should -BeIn "John", "Jane", "Joe", "Jill", "Jack"
    }
}
# test greetPerson function
Describe "greetPerson" {
    It "should greet a person" {
        "John" | greetPerson | Should -Be "Hello John"
    }
}
# test greetPerson function that uses the pipeline
Describe "greetPerson" {
    It "should greet a person from the pipeline" {
        generateNames | greetPerson | Should -BeLike "Hello *"
    }
}
# test greetPerson function that uses the pipeline and the -TestCases parameter
Describe "greetPerson" {
    It "should greet a person from the pipeline" -TestCases @(
        @{name = "John"}
        @{name = "Jane"}
        @{name = "Joe"}
        @{name = "Jill"}
        @{name = "Jack"}
    ) {
        param($name)
        $name | greetPerson | Should -BeLike "Hello *"
    }
}
#

