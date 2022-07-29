(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using DTprototype
const UserApp = DTprototype
DTprototype.main()
