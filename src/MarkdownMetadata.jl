module MarkdownMetadata

include("MetadataClasses.jl")
include("MetadataFunctions.jl")

using .MetadataClasses
using .MetadataFunctions

Base.Dict(pairs::Pair{MetadataCategory, Any}...) = Dict{MetadataCategory, Any}(pairs)

export MetadataCategory, MetadataContainer, add_metadata, update_metadata, get_allowed_types, get_existing_keys, clear_metadata, update_category_name, remove_metadata

end # module MarkdownMetaData
