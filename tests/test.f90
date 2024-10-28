program test
  use iso_fortran_env, only : sp => real32
  implicit none

  integer :: i

  do i = 1, 10
     call progress_bar(i/10.0)
     call sleep(1)
  end do
  print*, ' '
end program test
