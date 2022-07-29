module TestMoo
using Revise
include("src/SlideUI.jl")
using .SlideUI
Revise.track(SlideUI)

export testfoo
function testfoo()
    foo()
end
end