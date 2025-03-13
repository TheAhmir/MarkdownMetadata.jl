using MarkdownMetadata

println()

println("Executing Function Tests")

println()

@testset "test reading files" begin
    @test length(read_docs("./testfiles")) == 5
    println(extract_metadata(:markdown, "./testfiles/test1.md"))
end
