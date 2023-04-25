using Test
using CodeAI


const config = CodeAI.Configuration()

@testset "CodeAI.jl" begin

  models = CodeAI.models(config)
  @test !isempty(models)

  model = CodeAI.model(config, models[begin].id)
  @test hasproperty(model, :id)
  @test models[begin].id == model.id

  # Generates a Hello World function in Julia
  code = CodeAI.julia(config, "return 'Hello World'")
  code |> Meta.parse |> eval
  @test hello_world() == "Hello World"

  # Refactors the Hello World function to Hello Universe, without changing the function name
  code = CodeAI.refactor(config, "Replace 'Hello World' with 'Hello Universe'")
  code |> Meta.parse |> eval
  @test hello_world() == "Hello Universe"

  # Refactors the Hello World function to a new function in Spanish
  code = CodeAI.refactor(config, "Translate 'Hello World' to Spanish"; implementation_only = false)
  code |> Meta.parse |> eval
  @test hola_mundo() == "Hola Mundo"

  # Generate code without a function
  code = CodeAI.julia(config, "Return just the string 'Goodbye!'"; implementation_only = true)
  code |> Meta.parse |> eval
  @test code == "\"Goodbye!\""

  # Explain last generated code
  # CodeAI.explain(config)

end
