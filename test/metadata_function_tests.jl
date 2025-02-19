using Test, MarkdownMetadata, Dates

println()

println("Executing Function Tests")

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

    # error: no duplicate category names
    md = MetadataContainer()
    attr1 = MetadataCategory("duplicate-title", String)
    attr2 = MetadataCategory("tags", Vector{String})
    attr3 = MetadataCategory("duplicate-title", String)
    to_add = [
        attr1 => "this is a title"
        attr2 => [
            "tag1",
            "tag2",
            "tag3"
        ]
        attr3 => "this title is a duplicate"
    ]
    @test_throws ErrorException add_metadata(md, to_add)

    # add multiple categories to metadata using strings
    md = MetadataContainer()
    to_add = [
        "title" => "this is a title",
        "created_at" => Dates.now(),
        "summary" => "this is a summary for a document. Am i wasting my time making this work?"
    ]
    add_metadata(md, to_add)
    @test length(md.metadata) == 3
    @test first(md.metadata[2]).datatype == DateTime

    # error: no duplicates
    @test_throws ErrorException add_metadata(md, "summary", "this is a duplicate summary category")

    # error: no whitespace in keys
    @test_throws ErrorException add_metadata(md, "another category", "hellllllooooo")

    # can add a valid singular value to this metadata
    add_metadata(md, "title2", "filler category")
    @test length(md.metadata) == 4
end

println()

@testset "Clear Metadata Function tests" begin
    md = MetadataContainer()
    add_metadata(md, "title", "this is a title")
    @test length(md.metadata) == 1
    clear_metadata(md)
    @test length(md.metadata) == 0
end

println()

@testset "Update Metadata Function tests" begin
    # update value of key in MetadataContainer using a string
    md = MetadataContainer(
        ["title" => "this is a title"]
    )
    @test length(md.metadata) == 1
    @test last(md.metadata[1]) == "this is a title"

    update_metadata(md, "title", "this title has been changed")
    @test length(md.metadata) == 1
    @test last(md.metadata[1]) == "this title has been changed"

    # update value of key in MetadataContainer using exact MetadataCategory
    md = MetadataContainer()
    attr1 = MetadataCategory("title", String)
    add_metadata(md, attr1, "this is a title")
    update_metadata(md, attr1, "changed title")
    @test last(md.metadata[1]) == "changed title"
end

println("---")
