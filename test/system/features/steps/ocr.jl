using Images
using ExecutableSpecifications: @given, @when, @then, @expect

using OCReract

# Util path to locate the files for testing
pkg_path = abspath(joinpath(dirname(pathof(OCReract)), ".."))

# Items to be used in tests
TEST_ITEMS = Dict(
    "simple" => Dict(
        "path" => "$(pkg_path)/test/files/testocr.png",
        "text" => "This is a lot of 12 point text to test the\n"*
                  "ocr code and see if it works on all types\n"*
                  "of file format.\n\n"*
                  "The quick brown dog jumped over the\n"*
                  "lazy fox. The quick brown dog jumped\n"*
                  "over the lazy fox. The quick brown dog\n"*
                  "jumped over the lazy fox. The quick\n"*
                  "brown dog jumped over the lazy fox."
    ),
    "noisy" => Dict(
        "path" => "$(pkg_path)/test/files/noisy.png",
        "text" => "Noisy image\nto test\nOCReract.jl"
    )
)

@given "a valid path to an input image" begin
    context[:input_path] = TEST_ITEMS["simple"]["path"]
    context[:input_text] = TEST_ITEMS["simple"]["text"]
end

@given "a valid path to an output text file" begin
    tmp_path = tempname()
    mkdir(tmp_path)
    context[:output_path] = tmp_path*"/res.txt"
end

@given "an invalid language" begin
    :kwargs in keys(context.variables) ? 
        context[:kwargs][:lang] = "not-valid-language" :
        context[:kwargs] = Dict(:lang => "not-valid-language")
end


@when "I run OCReract with an image in disk" begin
    kwargs = :kwargs in keys(context.variables) ? context[:kwargs] : Dict()
    context[:result] = run_tesseract(context[:input_path], context[:output_path]; kwargs...)
end


@when "I run OCReract with an image in disk twice" begin
    res = run_tesseract(context[:input_path], context[:output_path])
    # Again to test warning about already existing output file
    res = run_tesseract(context[:input_path], context[:output_path])
    context[:result] = res
end

@when "I run OCReract with an image in memory" begin
    image = Images.load(context[:input_path])
    context[:output_text] = run_tesseract(image)
    context[:result] = true
end

@then "a warning is thrown about existing text file" begin
    # Nothing to do...
end


@then "the text is correctly extracted" begin
    @expect context[:result] == true

    if :output_path in keys(context.variables)
        result_txt = ""
        open(context[:output_path], "r") do f
            context[:output_text] = read(f, String)
        end
    end

    @expect strip(context[:output_text]) == strip(context[:input_text])
end

@then "the result is false" begin
    @expect context[:result] == false
end
