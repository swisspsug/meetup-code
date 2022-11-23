# create a function to add two numbers
function addTwoNumbers {
    param(
        [int]$num1,
        [int]$num2
    )
    $num1 + $num2
}

# call the function
addTwoNumbers -num1 5 -num2 10

# create a function to add an array of numbers
function addArrayNumbers {
    param(
        [int[]]$numArray
    )
    $numArray | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

# call the function
addArrayNumbers -numArray @(1,2,3,4,5)

# create a function that with no params generates names of people
function generateNames {
    $names = @("John", "Jane", "Joe", "Jill", "Jack")
    $names | Get-Random -Count 1
}

# create a function that accepts the name of a person from the value in pipeline and returns a greeting
function greetPerson {
    param(
        [parameter(ValueFromPipeline=$true)]
        [string]$name
    )
    "Hello $name"
}

# call the function
generateNames | greetPerson