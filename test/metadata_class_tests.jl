using Test, MarkdownMetadata, Dates

println()

println("Executing Class Tests")

println()

@testset "MetadataCategory Class tests" begin
    # print allowed allowed types
    @test get_allowed_types() == Union{String, Int, Float64, Bool, Dates.Date, Dates.DateTime, Vector{String}}
    
    # error: Category with unacceptable datatype
    @test_throws MethodError  MetadataCategory("invalid", Dict)

    # error: Category missing an agument
    @test_throws MethodError MetadataCategory("invalid")

    # error: Category missing all arguments
    @test_throws MethodError MetadataCategory()

    # error: Category name is not a string
    @test_throws MethodError MetadataCategory(1, String)

    # error: category name can't contain whitespace
    @test_throws ErrorException MetadataCategory("this is a title", String)

    # correct assignment of attributes
    md = MetadataCategory("title", String)
    @test typeof(md) == MetadataCategory
    @test md.name == "title"
    @test md.datatype == String
end

println()

@testset "Metadata Class tests" begin

    """
        MetadataContainer class tests
    """
    # error: argument of wrong type
    @test_throws MethodError MetadataContainer("String")

    # create empty MetadataContainer
    md = MetadataContainer()
    @test typeof(md) == MetadataContainer
    @test md.metadata == Pair{MetadataCategory, Any}[]

    # initialize with MetadataCategory
    attr1 = MetadataCategory("title", String)
    attr2 = MetadataCategory("tags", Vector{String})
    vector = [
        (attr1 => "this is a title"),
        (attr2 => ["tag1", "tag2"])
    ]
    md = MetadataContainer(vector)
    @test length(md.metadata) == 2
    
    # error: categories can't have the same name
    attr1 = MetadataCategory("title", String)
    attr2 = MetadataCategory("title", Int)
    vector = [
        attr1 => "this",
        attr2 => "that"
    ]
    @test_throws ErrorException MetadataContainer(vector)

    # initialize with raw data
    vector = [
        "title" => "this is a title",
        "tages" => ["tag1", "tag2"]
    ]
    md = MetadataContainer(vector)    
    @test length(md.metadata) == 2

    # error: raw data key can't have whitespace
    vector = [
        "this is a title" => "String"
    ]
    @test_throws ErrorException MetadataContainer(vector)
    
    # error: raw data can't have duplicate keys
    vector = [
        "duplicate" => "this is a title"
        "duplicate" => ["this", "is", "the", "same"]
    ]
    @test_throws ErrorException MetadataContainer(vector)
end

println("---")
