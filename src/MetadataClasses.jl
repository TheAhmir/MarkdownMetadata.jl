module MetadataClasses

using Dates

export MetadataCategory, MetadataContainer, get_allowed_types

# only allow specific values that are accepted in markdown, Yaml, Toml, JSON, and Latex
const ALLOWED_TYPES = Union{String, Int, Float64, Bool, Dates.Date, Dates.DateTime, Vector{String}}

# function to get allowed types
"""
    get_allowed_types()

Get list of all types accepted in MetadataCategory.
"""
function get_allowed_types()::Union{<:Type}
    return ALLOWED_TYPES
end

# Class to enforce structured typing of metadata
"""
    MetadataCategory
"""
struct MetadataCategory
    name::String
    datatype::Type
    """
        struct MetadataCategory(name::String, datatype::Type{T})
    """
    function MetadataCategory(name::String, datatype::Type{T}) where T <: ALLOWED_TYPES 
        if contains(name, " ")
            error("Whitespace is not allowed in keys names.")
        end
        new(name, datatype)
    end
end

# Class containing all data to write metadata
"""
    MetadataContainer
"""
struct MetadataContainer
    metadata::Vector{Pair{MetadataCategory, <:Any}}
    
    # empty initialization
    """
        struct MetadataContainer()
    """
    function MetadataContainer()
        new(Vector{Pair{MetadataCategory, <:Any}}())
    end
    
    # allow class creation with raw values
    """
        struct MetadataContainer(metadata::Vector{Pair{String, T}})
    """
    function MetadataContainer(metadata::Vector{Pair{String, T}}) where T <: Any
        data = Vector{Pair{MetadataCategory, <:Any}}()
        seen_keys = Set{String}()
        for (key, value) in metadata
            if contains(key, " ")
                error("Whitespace are not allowed in key names.")
            elseif key in seen_keys
                error("All keys must be unique.")
            else
                push!(seen_keys, key)
                new_item = MetadataCategory(key, typeof(value))
                push!(data, (new_item => value))
            end    
        end

        new(data)
    end
    
    # more structured classes creation
    """
        struct MetadataContainer(metadata::Vector{Pair{MetadataCategory, T}})
    """
    function MetadataContainer(metadata::Vector{Pair{MetadataCategory, T}}) where T <: Any
        if isempty(metadata)
            new(metadata)
        else
            counts = Dict()
            for (key, value) in metadata
                if haskey(counts, key.name)
                    counts[key.name] += 1
                else
                    counts[key.name] = 1
                end
            end

            if !(all(x -> typeof(first(x)) == MetadataCategory, metadata))                error("All keys must be of type MetadataCategory")
            elseif any(x -> x > 1, values(counts))
                error("Duplicate found in category. Each category must have a unique key")
            end
            new(metadata)
        end
    end
end

end
