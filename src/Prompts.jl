module Prompts


const PROMPT = Ref("")
const EOR = "::end::"


function system(lang = "Julia"; fn = true, fname::Union{Nothing, String} = nothing, dc = fn)
  prompt = """
    You are an expert $lang developer and generate high quality $lang code.
    You answer only with JSON, in the following format: "
    {"r":{"c":"<response>","e":"<error>"}}
    ".
    If you don't know the answer, leave `c` empty and set `e` to your error message explaining how to improve the request.
    Escape single quotes with backslash in your response.
    Finish your answer with `$EOR`.
  """

  fn && (prompt *= """
    Wrap code in a function.
  """)

  if fname !== nothing
    prompt *= "The function name is $fname."
  elseif fn
    prompt *= "Pick function name to reflect functionality."
  end

  dc && (prompt *= """
    Add doc string to function. Do not wrap the doc string in backticks.
  """)

  lowercase(lang) == "julia" && (prompt *= """
    Use as much as possible Julia's built-in functions and libraries and the most popular packages.
    Use the most popular style guide and best practices and idiomatic Julia code.
    Add type annotations to function arguments and return values.
  """)

  lowercase(lang) == "html" && (prompt *= """
    Don't generate the whole HTML document, only the requested HTML snippet.
  """)

  PROMPT[] = prompt

  return prompt
end


function refactor(code::String, prompt::String; implementation_only = true, fn = true)
  prompt = """
    Refactor the following code:
    ```
    $code
    ```

    Change it so that $prompt.

  """

  implementation_only && fn && (prompt *= """
    You can only change the implementation of the function. Do not change the function name.
  """)

  return prompt
end


function explain(code::String, prompt::String = "")
  prompt = """
    Explain the following code:
    ```
    $code
    ```

    $prompt
  """

  PROMPT[] = prompt

  return prompt
end


function debug(code::String, error::String, prompt::String = "")
  prompt = """
    Debug the following code by replacing the current code with your fixed code:
    ```
    $code
    ```

    The code throws the following error:
    ```
    $error
    ```

    $prompt
  """

  PROMPT[] = prompt

  return prompt
end


function prompt()
  return PROMPT[]
end

end