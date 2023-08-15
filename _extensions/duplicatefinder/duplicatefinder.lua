-- task: log to console all #fig-<whatever>


--[[local function findDuplicateWords(list)
   for _, v in pairs(list) do
    quarto.log.output(v.text)
    end
end

return {
Pandoc = function(doc)
    -- find duplicates in the document
    local filter = {
        Blocks = findDuplicateWords,
        Inlines = findDuplicateWords
    }
    doc.blocks:walk(filter)

    return doc
end  
}
--]]


-- Function to find duplicate words starting with a specific prefix in a list of words
--[[local function findDuplicateWordsWithPrefix(words, prefix)
    local seenWords = {}
    local duplicateWords = {}

    for _, word in ipairs(words) do
        if word:sub(1, #prefix) == prefix then
            if seenWords[word] then
                duplicateWords[word] = true
            else
                seenWords[word] = true
            end
        end
    end

    return duplicateWords
end

Pandoc = function(doc)
    local prefixes = {"#fig-", "#tbl-", "#sec-", "#eq-"} -- List of prefixes to search for
    local allWords = {} -- Store all words from the document

    -- Collect all words from the entire document
    for _, block in pairs(doc.blocks) do
        if block.t == "Para" then
            local words = {}

            for _, inline in ipairs(block.content) do
                if inline.t == "Str" then
                    table.insert(words, inline.text)
                end
            end

            for _, word in ipairs(words) do
                table.insert(allWords, word)
            end
        end
    end

    for _, prefix in ipairs(prefixes) do
        local duplicateWords = findDuplicateWordsWithPrefix(allWords, prefix)

        for word, _ in pairs(duplicateWords) do
            quarto.log.output("Duplicate word with prefix " .. prefix .. ": " .. word)
        end
    end

    return doc
end
--]]
local seen_identifiers = {}
local identifier_counts = {}

function Pandoc(doc)
    for _, block in ipairs(doc.blocks) do
        local anchor = block.identifier
        if anchor then
            if seen_identifiers[anchor] then
                identifier_counts[anchor] = (identifier_counts[anchor] or 1) + 1
                quarto.log.error("Duplicate anchor identifier found: " .. anchor .. " (" .. identifier_counts[anchor] .. " times)")
            else
                seen_identifiers[anchor] = true
            end
        end
    end

    return doc
end

return {
    {Pandoc = Pandoc}
}



