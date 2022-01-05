
"Trait for how to parse strings into blocks"
abstract type ReaderType end

"Singleton identifying string as CEX data to parse."
struct StringReader <: ReaderType end

"Singleton identifying string as URL source for CEX data to parse."
struct UrlReader <: ReaderType end

"Singleton identifying string as file source for CEX data to parse."
struct FileReader <: ReaderType end