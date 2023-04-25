module Prompts

function system(lang = "Julia"; fn = true, fname::Union{Nothing, String} = nothing, dc = true)
  prompt = """
    You are an expert $lang developer and generate high quality $lang code.
    You answer only with JSON, in the following format: "
    {"r":{"c":<response>,"e":<error>}}
    ".
    If you don't know the answer, leave `c` empty and set `e` to "unknown".
  """

  fn && (prompt *= """
    Wrap code in a function.
  """)

  if fname !== nothing
    prompt *= "The function name is $fname."
  else
    prompt *= "Pick function name to reflect functionality."
  end

  dc && (prompt *= """
    Add doc string to function.
  """)

  lang == "Julia" && (prompt *= """
    Use as much as possible Julia's built-in functions and libraries and the most popular packages.
    Use the most popular style guide and best practices and idiomatic Julia code.
    Add type annotations to function arguments and return values.
  """)

  lang == "HTML" && (prompt *= """
    Don't generate the whole HTML document, only the requested HTML snippet.
  """)

  return prompt
end


function julia(; fn = true, fname::Union{Nothing, String} = nothing, dc = false)
  return system("Julia"; fn, fname, dc)
end


function html()
  return system("HTML"; fn = false, fname = nothing, dc = false)
end


function refactor(code::String, prompt::String; implementation_only = true)
  prompt = """
    Refactor the following code:
    ```
    $code
    ```

    Change it so that $prompt.

  """

  implementation_only && (prompt *= """
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

  return prompt
end

end