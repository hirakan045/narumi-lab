! make txt for HGT_M
!   ncdump -v HGT_M geo_em.d03.nc > hgt_m.txt
!
! revise hgt_m.txt file
!
! compile this fortran program, 
!   gfortran rewrite_landuse.f90 -L/usr/local/netcdf-4.1.3/lib -lnetcdf -L/usr/lib -lnetcdff
!----------------------------------------------------------------------------------------------------
!
program main
!
  implicit none
  include '/usr/local/netcdf-4.1.3/include/netcdf.inc'
!
  integer, parameter :: lats=120, lons=120                  ! 次元長      解析領域に応じ変更する必要あり!
  integer istatus, id_nc                                    ! netCDF ID
  integer ilon, ilat
  integer id_hgtm                                           ! 変数 ID
  real(4) :: hgtm(lons, lats)                               ! 変数 HGT_M
  real(4) :: rw_hgtm(lons, lats)                            ! 上書きするLANDUSEF
!
! --- netCDF fileを開く
  istatus = nf_open ('geo_em.d03.nc', nf_write, id_nc)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
! --- 各変数のIDを取得する
  istatus = nf_inq_varid (id_nc, 'HGT_M', id_hgtm)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
! --- 値を取得
! --- HGT_M
  istatus = nf_get_var_real (id_nc, id_hgtm, hgtm)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
! --- 上書きするファイルを開く
  open(100,file='hgt_m.txt')
! ---
  do ilat = 1, lats
    read(100,*) (rw_hgtm(ilon, ilat), ilon = 1, lons)
  enddo

! --- 各変数の書き換え
  hgtm(:,:) = rw_hgtm(:,:)
!
! --- 変数の書き換え後の値をnetCDF fileに書き込む
  istatus = nf_put_var_real (id_nc, id_hgtm, hgtm)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
!
! --- netCDF fileを閉じる
  istatus = nf_close(id_nc)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  print *,'*** success re-writing HGT_M! ***'
!
end program main
!
!
subroutine handle_err(istatus)
!エラーメッセージを出して止めるsubroutine
  integer istatus
  write(*,*) nf_strerror(istatus)
  stop
end subroutine handle_err
