using ExecutableSpecifications
using Test

@testset "OCReractTest" begin
    # include("test_tesseract.jl")
    runspec("../test/system")
end