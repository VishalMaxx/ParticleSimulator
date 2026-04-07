module types
    implicit none
    type :: Particle
        real(8) :: x(3)
        real(8) :: v(3)
        real(8) :: f(3)
        real(8) :: mass
        real(8) :: radius
    end type Particle
end module types
