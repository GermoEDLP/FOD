 program tp2_4;
 uses Crt, sysutils;
 const v_a = 9999;
 const cant_maquinas = 5;
 type
    str20 = string[20];
    conexiones = record
        cod: integer;
        fecha: str20;
        tiempo_total_de_sesiones_abiertas: integer;
    end;
    maquina = record
        cod: integer;
        fecha: str20;
        tiempo: integer;
    end;
    maestro = file of conexiones;
    detalle = file of maquina;

procedure leer(	var archivo: detalle; var maquina: maquina);
begin
    if (not(EOF(archivo))) then 
       read (archivo, maquina)
    else 
		    maquina.cod := v_a;
end;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Crear archivos maquinas.dat');
    writeln('2. Crear maestro.dat');
    writeln('3. Exportar maestro.txt');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar(tipo: str20);
var
    mae: maestro;
    det: detalle;
    regmae: conexiones;
    regdet: maquina;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'dataEj4/dat/'+tipo+'.dat');
            rewrite(mae);
            assign(texto, 'dataEj4/conexiones.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regmae.cod, regmae.tiempo_total_de_sesiones_abiertas, regmae.fecha);
                write(mae, regmae);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo conexiones.txt importado en maestro.dat correctamente!!');
            writeln();
        end;
        else 
            assign(det, 'dataEj4/dat/'+tipo+'.dat');
            rewrite(det);
            assign(texto, 'dataEj4/'+tipo+'.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet.cod, regdet.tiempo, regdet.fecha);
                write(det, regdet);
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivo '+tipo+'.txt importado en '+tipo+'.dat correctamente!!');
            writeln();
        
    end;
end;

procedure exportar(tipo: str20);
var
    mae: maestro;
    regmae: conexiones;
    texto: Text;
begin
    assign(mae, 'dataEj4/dat/maestro.dat');
    reset(mae);
    assign(texto, 'dataEj4/var/log/maestro.txt');
    rewrite(texto);
    while(not eof(mae)) do begin
        read(mae, regmae);
        writeln(texto, regmae.cod, ' ',regmae.tiempo_total_de_sesiones_abiertas, regmae.fecha);
    end;
    close(mae);
    close(texto);
    ClrScr;
    writeln('Archivo maestro.dat exportado en maestro.txt correctamente!!');
    writeln(); 
end;

procedure crearMae();
var
    mae: maestro;
    det: detalle;
    regm: conexiones;
    regd: maquina;
    cont: integer;
    userMax: integer;
begin
    cont:=0;
    userMax:=0;
    assign(mae, 'dataEj4/dat/maestro.dat');
    rewrite(mae);
    for cont:=1 to cant_maquinas do begin
        assign(det, 'dataEj4/dat/maquina'+IntToStr(cont)+'.dat');
        reset(det);
        leer(det, regd);
        while(regd.cod <> v_a) do begin
            if(regd.cod>userMax)then 
                userMax:=regd.cod;
            leer(det, regd);
        end;
        close(det);
    end;
    for cont:=1 to userMax do begin
        regm.cod:=cont;
        regm.tiempo_total_de_sesiones_abiertas:=0;
        regm.fecha:=' ';
        write(mae, regm);
    end;
    close(mae);
end;

procedure cargarAlArchivoMaestro(detalle: str20);
var
    mae: maestro;
    det: detalle;
    regm: conexiones;
    regd: maquina;
    aux: integer;
    total_tiempo: integer;
begin
    assign(mae, 'dataEj4/dat/maestro.dat');
    assign(det, 'dataEj4/dat/'+detalle+'.dat');
    reset(mae);
    reset(det);
    read(mae, regm);
    leer(det, regd);
    while (regd.cod <> v_a) do begin
        aux := regd.cod;
        total_tiempo:=0;
        while (aux = regd.cod) do begin
            total_tiempo:=total_tiempo+regd.tiempo;
            leer(det, regd);
        end;
        writeln('Suma detalle: ', aux, ' ', total_tiempo);
        readln();
        while(regm.cod<>aux)do
            read(mae, regm);
        regm.tiempo_total_de_sesiones_abiertas:=regm.tiempo_total_de_sesiones_abiertas+total_tiempo;
        regm.fecha:=regd.fecha;
        seek(mae, filePos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then 
            read(mae, regm);
    end;
    close(det);
    close(mae);
    writeln('Archivo maestro.dat actualizado correctamente en base a '+detalle+'.dat!!');
    writeln();
end;

var
    fin: boolean;
    opc: integer;
    cont: integer;
begin
    fin:=false;
    ClrScr;
    repeat
        opc:= menu();
        case opc of
            1: begin
                for cont:=1 to cant_maquinas do
                    importar('maquina'+IntToStr(cont));
            end;
            2: begin
                crearMae();
                for cont:=1 to cant_maquinas do
                    cargarAlArchivoMaestro('maquina'+IntToStr(cont));
            end;
            3: begin
                exportar('maestro');
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);          
end.