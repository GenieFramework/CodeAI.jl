using Test
using CodeAI


const config = CodeAI.Configuration()

# @testset "CodeAI.jl" begin
  # models = CodeAI.models(config)
  # @test !isempty(models)

  # model = CodeAI.model(config, models[begin].id)
  # @test hasproperty(model, :id)
  # @test models[begin].id == model.id

  # Generates a Hello World function in Julia
  code = CodeAI.julia(config, "Hello World")
  code |> Meta.parse |> eval
  hello_world()

  # Refactors the Hello World function to Hello Universe, without changing the function name
  code = CodeAI.refactor(config, "Replace Hello World with Hello Universe")
  code |> Meta.parse |> eval
  hello_world()

  # Refactors the Hello World function to a new function in Spanish
  code = CodeAI.refactor(config, "Translate Hello World to Spanish"; implementation_only = false)
  code |> Meta.parse |> eval
  hola_mundo()

  # Generate code without a function
  code = CodeAI.julia(config, "Say goodbye"; implementation_only = true)
  code |> Meta.parse |> eval

  # Explain last generated code
  CodeAI.explain(config)


# end
