class SolveProblemJob < ActiveJob::Base
  queue_as :default

  def perform(students,sections, assignments_fte, assignments_is_fixed )
    begin
             problem = ::IntegerLinearProgram.new(students.gtas_approved, sections, assignments_fte, assignments_is_fixed, {}, false)
             problem.solve
             assignments_fte = problem.results
#             problem.print_results
   
           rescue RuntimeError
             flash[:alert] = "Infeasible solution"
      end
    assignment = Assignment.create(assignments_fte: assignments_fte, assignments_is_fixed: assignments_is_fixed)

  end
  
end
