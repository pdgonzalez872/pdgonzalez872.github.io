ExUnit.start()

defmodule VM  do
  defmodule Calculator do
    @moduledoc """
    A stack based calculator.

    Notes:
    - I'm ommitting @spec, @doc for simplicity
    - Instead of growing downwards like the usual examples, the stack "grows to
      the left".
    - Error handling can be more robust. At this time, we are just handling happy
      paths and hoping people don't input things like "4+a/1"

    Resources:
    - "The Elements of Computer Systems"
    - http://www2.lawrence.edu/fast/GREGGJ/CMSC150/071Calculator/Calculator.html
    """

    @supported_operands ["(", ")", "*", "/", "+", "-"]

    def call(expression) when is_binary(expression) do
      calculate([], [], String.split(expression, " ", trim: true))
    end

    defp calculate([final_value], [], []) do
      final_value
    end

    defp calculate(
           values,
           [_ | _] = operands,
           ["(" = h_expression | t_expression]
         ) do
      operands = increment_stack(operands, h_expression, :operand)
      calculate(values, operands, t_expression)
    end

    defp calculate(
           values,
           [_ | _] = operands,
           [")" | t_expression]
         ) do
      calculate(values, operands, t_expression)
    end

    defp calculate(values, operands, [last_token]) do
      values = increment_stack(values, last_token, :value)
      operands = increment_stack(operands, last_token, :operand)
      [a, b | t_values] = values
      [operand | t_operands] = operands
      result = evaluate([a, b], operand)
      calculate([result | t_values], t_operands, [])
    end

    defp calculate(
           values,
           operands,
           [h_expression | t_expression] = expression
         ) do
      with {:has_two_values, [_a, _b | _]} <- {:has_two_values, values},
           {:current_operand, [current_operand | _]} <- {:current_operand, operands},
           {:next_token, [next_token | _]} <- {:next_token, expression},
           {:next_token_is_operand, true} <- {:next_token_is_operand, is_operand(next_token)},
           {:current_operand_is_parens, false} <-
             {:current_operand_is_parens, current_operand == "(" or current_operand == ")"},
           {:precedence, false} <-
             {:precedence, precedence_value(next_token) > precedence_value(current_operand)} do
        [a, b | t_values] = values
        [operand | t_operands] = operands
        result = evaluate([a, b], operand)
        calculate([result | t_values], t_operands, expression)
      else
        _reason ->
          values = increment_stack(values, h_expression, :value)
          operands = increment_stack(operands, h_expression, :operand)
          calculate(values, operands, t_expression)
      end
    end

    defp calculate(
           [_, _ | _] = values,
           ["(" | t_operands],
           [] = expression
         ) do
      calculate(values, t_operands, expression)
    end

    defp calculate(
           [a, b | t_values],
           [h_operands | t_operands],
           [] = expression
         ) do
      result = evaluate([a, b], h_operands)
      calculate([result | t_values], t_operands, expression)
    end

    # The order in the args here matters. Since this is a stack, the list
    # "head" is actually the stack's last element.
    defp evaluate([a, b], "+") do
      b + a
    end

    defp evaluate([a, b], "-") do
      b - a
    end

    defp evaluate([a, b], "*") do
      b * a
    end

    defp evaluate([a, b], "/") do
      b / a
    end

    defp increment_stack(stack, token, :value) do
      if is_value(token) do
        {int, _} = Integer.parse(token)
        [int | stack]
      else
        stack
      end
    end

    defp increment_stack(stack, token, :operand) do
      if is_operand(token), do: [token | stack], else: stack
    end

    defp is_operand(token) when token in @supported_operands, do: true
    defp is_operand(_), do: false

    defp is_value(token), do: !is_operand(token)

    defp precedence_value(operand) do
      case operand do
        "*" -> 2
        "/" -> 2
        "+" -> 1
        "-" -> 1
        e -> raise "not implemented yet #{inspect(e)}"
      end
    end
  end

  #
  # Tests
  #

  use ExUnit.Case

  describe "StackArithmetic" do
    @tag :solved
    test "calculates expressions, solved" do
      assert 10 ==  Calculator.call("4 + 6")
      assert 24 == Calculator.call("4 * 6")
      assert 8 == Calculator.call("2 + 3 * 4 - 6")
      assert 34 == Calculator.call("4 + 5 * 6")
      assert 2 == Calculator.call("3 / 3 + 1")
      assert 2 == Calculator.call("3 / 3 + 4 / 4")
      assert 8 == Calculator.call("4 * ( 4 - 2 )")
      assert 8 == Calculator.call("4 * ( 6 - 2 * ( 4 - 2 ) )")
      assert 27 == Calculator.call("4 / 2 + 8 * 4 - ( 5 + 2 )")
    end

    @tag :in_progress
    test "calculates expressions, in progress" do
      # Add more expressions you'd like to try here, see the test fail and work
      # on it until it passes! Then, move them above and keep going.
      assert true
    end
  end
end
