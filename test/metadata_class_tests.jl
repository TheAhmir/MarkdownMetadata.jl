using Test
using MarkdownMetadata
using Dates

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

println()

@testset "Add Metadata Function tests" begin
    # add category to metadata
    md = MetadataContainer()
    @test length(md.metadata) == 0
    attribute1 = MetadataCategory("title", String)
    add_metadata(md, attribute1, "This is a title")
    @test length(md.metadata) == 1
    @test typeof(first(first(md.metadata))) == MetadataCategory
    @test typeof(last(first(md.metadata))) == String

    # error: can't have duplicates
    @test_throws ErrorException add_metadata(md, attribute1, "This is a second title")

    # add category to metadata using strings
    md = MetadataContainer()
    add_metadata(md, "title", "this is a title")
    @test length(md.metadata) == 1
    @test typeof(first(first(md.metadata))) == MetadataCategory
    @test typeof(last(last(md.metadata))) == String

    # error: still can't have duplicates
    @test_throws ErrorException add_metadata(md, "title", "this is a second title")
    
    # add multiple categories to metadata
    md = MetadataContainer()
    attr1 = MetadataCategory("title", String)
    attr2 = MetadataCategory("tags", Vector{String})
    attr3 = MetadataCategory("date", DateTime)
    add_metadata(md, [
        attr1 => "this is a title",
        attr2 => [
            "tag1",
            "tag 2",
            "tag 3"
        ],
        attr3 => Dates.now()
    ])
    @test length(md.metadata) == 3
end

println()

@testset "Update Metadata Function tests" begin
    @test true == true
end
