let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/proj/traffic
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +2 ~/proj/traffic/exp.rb
badd +1 ~/proj/traffic/test.csv
badd +12 ~/proj/traffic/process.R
badd +500 ~/proj/traffic/interArrivalFile.csv
badd +499 ~/proj/traffic/serviceFile.csv
badd +241 ~/proj/traffic/simulation.rb
badd +1 ~/proj/traffic/interarrival_lambda_0.csv
badd +1 ~/proj/traffic/interarrival_lambda_1.csv
badd +1 ~/proj/traffic/interarrival_lambda_2.csv
badd +501 ~/proj/traffic/interarrival_lambda_3.csv
badd +1 ~/proj/traffic/interarrival_lambda_4.csv
badd +2 ~/proj/traffic/interarrivals.csv
badd +1 ~/proj/traffic/interarrival_lambda_9.csv
badd +19 ~/proj/traffic/graph.R
badd +1 ~/proj/traffic/interarrival_lambda_3_ab_0_01.csv
badd +1 ~/proj/traffic/interarrival_lambda_5_ab_0_5.csv
badd +1 ~/proj/traffic/interarrival_lambda_5_ab_0_5.png
badd +1 ~/proj/traffic/data/interarrivals.csv
badd +1 ~/proj/traffic/data/services.csv
badd +2 ~/proj/traffic/interarrival_lambda_3_ab_0_5.png
badd +1 ~/proj/traffic/interarrival_lambda_3_ab_0_01.png
badd +1 ~/proj/traffic/service_mew_10.csv
badd +7 ~/proj/traffic/event.rb
badd +1 ~/proj/traffic/interarrival_lambda_3_ab_0_5.csv
badd +9 ~/proj/traffic/event_factory.rb
badd +517 ~/proj/traffic/1458173745_lam5b_0_5mew_10_results.csv
badd +519 ~/proj/traffic/1458174307_lam5_b0_5_mew10_results.csv
badd +769 ~/proj/traffic/1458174415_lam7_b0_5_mew10_results.csv
badd +19 ~/.vimrc
argglobal
silent! argdel *
edit ~/proj/traffic/exp.rb
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 2 - ((1 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:this_session = v:this_session
let g:this_obsession = v:this_session
let g:this_obsession_status = 2
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
