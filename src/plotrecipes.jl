@recipe function f(sim::ConvergenceSimulation)
  if ndims(collect(values(sim.errors))[1])>1 #Monte Carlo
    vals = [mean(x,1)' for x in values(sim.errors)]
  else #Deterministic
    vals = [x for x in values(sim.errors)]
  end
  seriestype --> :path
  label  --> reshape([string(key) for key in keys(sim.errors)],1,length(keys(sim.errors)))
  xguide  --> "Convergence Axis"
  yguide  --> "Error"
  xscale --> :log10
  yscale --> :log10
  sim.convergence_axis, vals
end

@recipe function f(shoot::Shootout)
  seriestype --> :bar
  legend := false
  xguide --> "Algorithms"
  yguide --> "Efficiency"
  shoot.names,shoot.effs
end

@recipe function f(wp::WorkPrecision)
  seriestype --> :path
  label -->  wp.name
  lw --> 3
  yguide --> "Time (s)"
  xguide --> "Error"
  xscale --> :log10
  yscale --> :log10
  wp.errors,wp.times
end

@recipe function f(wp_set::WorkPrecisionSet)
  seriestype --> :path
  label -->  reshape(wp_set.names,1,length(wp_set))
  lw --> 3
  yguide --> "Time (s)"
  xguide --> "Error"
  xscale --> :log10
  yscale --> :log10
  errors = Vector{Any}(0)
  times = Vector{Any}(0)
  for i in 1:length(wp_set)
    push!(errors,wp_set[i].errors)
    push!(times,wp_set[i].times)
  end
  errors,times
end

@recipe function f(tab::ODERKTableau;dx=1/100,dy=1/100,xlim=[-6,1],ylim=[-5,5])
  x = xlim[1]:dx:xlim[2]
  y = ylim[1]:dy:ylim[2]
  f = (u,v)-> abs(stability_region(u+v*im,tab))<1
  seriestype --> :contour
  fill --> true
  cbar --> false
  x,y,f
end
