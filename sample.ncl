
;;  model history file 

    fna = "model_freq_201001.nc" 

;;  site location information 

    fnb = "latlon.nc"

;;  output file 

    fno = "OUT_" + fna

    system("rm " + fno) 

    fla = addfile(fna, "r")   
    flb = addfile(fnb, "r")   
    flo = addfile(fno, "c")   

    lat = flb->lat
    lon = flb->lon

    ns = dimsizes(lat) 

    vn = getfilevarnames(fla)  ; get names of all variables on file

    nv = dimsizes (vn)   ; number of variables on the file

    time = fla->time


    do n=0,nv-1              ; loop thru each variable

       vv = fla->$vn(n)$        ; read the varible to memory
         
       ndim = dimsizes(vv)        ; dimension size of the variable
       nran = dimsizes(ndim)      ; rank [ie: number of dimensions]

       bname = vn(n) 
       wn    = bname

;;...........................................................  
;;     3-D 
;;...........................................................  

       if(nran.eq.3) then 
          va = vv 
          n1 = dimsizes(va(:,0,0)) 
          n2 = dimsizes(va(0,:,0)) 
          n3 = dimsizes(va(0,0,:)) 

          wn = bname

          wa = new((/n1,ns/),"float") 

          wa!1 = "st"
          wa&st = ispan(1,ns,1) 
          wa&st@long_name = "station" 

          wa!0 = "time"
          wa&time = time

          wa@long_name = va@long_name
          wa@units     = va@units

          ;; get grid-box mean value 

          do is = 0, ns-1 
             wa(:,is) = (/ va(:,{lat(is)},{lon(is)}) /)  
          end do 

          print(" varname : " + wn )               ; print all variable names on file
          flo->$wn$=wa

          delete(va) 
          delete(wa) 

       end if 
 
;;...........................................................  
;;     4-D 
;;...........................................................  

       if(nran.eq.4) then 

          va = vv 

          n1 = dimsizes(va(:,0,0,0)) 
          n2 = dimsizes(va(0,:,0,0)) 
          n3 = dimsizes(va(0,0,:,0)) 
          n4 = dimsizes(va(0,0,0,:))

          bname = vn(n)

          wn = bname

          wa = new((/n1,n2,ns/),"float")      

          wa!2 = "st"
          wa&st = ispan(1,ns,1)
          wa&st@long_name = "station"

          wa!0 = "time"
          wa&time = time

          wa!1 = "lev" 
          wa&lev = va&lev

          wa@long_name = va@long_name
          wa@units     = va@units

          ;; get grid-box mean value 

          do is = 0, ns-1
             wa(:,:,is) = (/ va(:,:,{lat(is)},{lon(is)}) /)
          end do

          print(" varname : " + wn )               ; print all variable names on file
          flo->$wn$=wa

          delete(va) 
          delete(wa) 

       end if 
 
       ;;print(" varname : " + wn )               ; print all variable names on file

       delete(ndim)
       delete(vv)

   end do




