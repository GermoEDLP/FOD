 program tp2_5;
 uses Crt, sysutils;
 const v_a = 9999;
 // Voy a analizar 2 sedes (nacimientos y defunciones), por un tema de escribir muchos archivos
 // pero esto puede exterderse a tantas sedes como archivos se tengan.
 const cant_sedes = 2;
 type
    str20 = string[20];
    str40 = string[40];
    nacimiento = record
        n_partida: integer;
        nombre: str20;
        apellido: str20;
        direccion: str40;
        matricula: integer;
        nom_ape_m: str20;
        dni_m: longint;
        nom_ape_p: str20;
        dni_p: longint;
    end;
    defuncion = record
        n_partida: integer;
        dni: longint;
        nom_ape: str40;
        matricula: integer;
        fecha_hora: str20;
        lugar: str20;
    end;
    persona = record
        n_partida: integer;
        nombre: str20;
        apellido: str20;
        direccion: str40;
        // Medico que firma el nacimiento
        matricula_n: integer;
        nom_ape_m: str20;
        dni_m: longint;
        nom_ape_p: str20;
        dni_p: longint;
        fallecio: str20;
        // Medico que firma la defunción
        matricula_d: integer;
        fecha_hora: str20;
        lugar: str20;
    end;
    maestro = file of persona;
    detalle_n = file of nacimiento;
    detalle_d = file of defuncion;

procedure leerNac(	var archivo: detalle_n; var nac: nacimiento);
begin
    if (not(EOF(archivo))) then 
       read (archivo, nac)
    else 
		    nac.n_partida := v_a;
end;

procedure leerDefun(	var archivo: detalle_d; var defun: defuncion);
begin
    if (not(EOF(archivo))) then 
       read (archivo, defun)
    else 
		    defun.n_partida := v_a;
end;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Crear archivos nac.dat');
    writeln('2. Crear archivos defun.dat');
    writeln('3. Crear maestro.dat');
    writeln('4. Cargar nacimientos al maestro.dat');
    writeln('5. Cargar defunciones al maestro.dat');
    writeln('6. Exportar maestro.txt');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar(tipo: str20; carpeta: str20);
var
    det_n: detalle_n;
    det_d: detalle_d;
    regdet_n: nacimiento;
    regdet_d: defuncion;
    texto: Text;
begin
    case tipo of
        'nac': begin
            assign(det_n, 'dataEj5/'+carpeta+'/nac.dat');
            rewrite(det_n);
            assign(texto, 'dataEj5/'+carpeta+'/nac.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet_n.n_partida, regdet_n.nombre);
                readln(texto, regdet_n.matricula, regdet_n.apellido);
                readln(texto, regdet_n.direccion);
                readln(texto, regdet_n.dni_m, regdet_n.nom_ape_m);
                readln(texto, regdet_n.dni_p, regdet_n.nom_ape_p);
                write(det_n, regdet_n);
            end;
            close(det_n);
            close(texto);
            ClrScr;
            writeln('Archivos de nacimientos importados correctamente!!');
            writeln();
        end;
        'defun': begin
            assign(det_d, 'dataEj5/'+carpeta+'/defun.dat');
            rewrite(det_d);
            assign(texto, 'dataEj5/'+carpeta+'/defun.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet_d.n_partida, regdet_d.nom_ape);
                readln(texto, regdet_d.dni, regdet_d.fecha_hora);
                readln(texto, regdet_d.matricula, regdet_d.lugar);
                write(det_d, regdet_d);
            end;
            close(det_d);
            close(texto);
            ClrScr;
            writeln('Archivos de defunciones importados correctamente!!');
            writeln();
        end;
    end;
end;

procedure crearMae();
var
    mae: maestro;
    // Selecciono nacimientos porque seguro que nacieron pero no que murieron
    det: detalle_n;
    regm: persona;
    regd: nacimiento;
    cont: integer;
    userMax: integer;
begin
    cont:=0;
    userMax:=0;
    assign(mae, 'dataEj5/maestro/maestro.dat');
    rewrite(mae);
    for cont:=1 to cant_sedes do begin
        assign(det, 'dataEj5/sede'+IntToStr(cont)+'/nac.dat');
        reset(det);
        leerNac(det, regd);
        while(regd.n_partida <> v_a) do begin
            if(regd.n_partida>userMax)then 
                userMax:=regd.n_partida;
            leerNac(det, regd);
        end;
        close(det);
    end;
    for cont:=1 to userMax do begin
        regm.n_partida:=cont;
        regm.fallecio:= 'No';        
        write(mae, regm);
    end;
    close(mae);
end;

procedure cargarAlArchivoMaestro(tipo: str20; carpeta: str20);
var
    mae: maestro;
    det_n: detalle_n;
    det_d: detalle_d;
    regm: persona;
    regd_n: nacimiento;
    regd_d: defuncion;
begin
    assign(mae, 'dataEj5/maestro/maestro.dat');
    reset(mae);
    case tipo of
        'nac': begin
            assign(det_n, 'dataEj5/'+carpeta+'/nac.dat');
            reset(det_n);
            read(mae, regm);
            leerNac(det_n, regd_n);
            while (regd_n.n_partida <> v_a) do begin
                while(regd_n.n_partida<>regm.n_partida) do 
                    read(mae, regm);
                regm.nombre:= regd_n.nombre ;
                regm.apellido:= regd_n.apellido ;
                regm.direccion:= regd_n.direccion ;
                regm.matricula_n:= regd_n.matricula ;
                regm.nom_ape_m:= regd_n.nom_ape_m ;
                regm.dni_m:= regd_n.dni_m ;
                regm.nom_ape_p:= regd_n.nom_ape_p ;
                regm.dni_p:= regd_n.dni_p ;
                seek(mae, filePos(mae)-1);
                write(mae, regm);
                leerNac(det_n, regd_n);
                if(not eof(mae)) then 
                    read(mae, regm);
            end;
            close(det_n);
            ClrScr;
            writeln('Archivo maestro.dat actualizado correctamente en base a los nacimientos!!');
            writeln();
        end;
        'defun': begin
            assign(det_d, 'dataEj5/'+carpeta+'/defun.dat');
            reset(det_d);
            read(mae, regm);
            leerDefun(det_d, regd_d);
            while (regd_d.n_partida <> v_a) do begin
                while(regd_d.n_partida<>regm.n_partida) do 
                    read(mae, regm);
                regm.fallecio:= 'Si';
                regm.matricula_d:= regd_d.matricula ;
                regm.fecha_hora:= regd_d.fecha_hora ;
                regm.lugar:= regd_d.lugar ;
                seek(mae, filePos(mae)-1);
                write(mae, regm);
                leerDefun(det_d, regd_d);
                if(not eof(mae)) then 
                    read(mae, regm);
            end;
            close(det_d);
            ClrScr;
            writeln('Archivo maestro.dat actualizado correctamente en base a las defunciones!!');
            writeln();
        end;
    end;
    close(mae);
    
end;

procedure exportar(tipo: str20);
var
    mae: maestro;
    regmae: persona;
    texto: Text;
begin
    assign(mae, 'dataEj5/maestro/maestro.dat');
    reset(mae);
    assign(texto, 'dataEj5/maestro/maestro.txt');
    rewrite(texto);

    while(not eof(mae)) do begin
        read(mae, regmae);
        writeln(texto, '================');
        writeln(texto, 'Partida N°: '+IntToStr(regmae.n_partida));
        writeln(texto, '================');
        writeln(texto, 'Nombre: '+regmae.nombre+' '+regmae.apellido);
        writeln(texto, 'Dirección: '+regmae.direccion);
        writeln(texto, ' ');
        writeln(texto, 'Acta de nacimiento');
        writeln(texto, '------------------');        
        writeln(texto, 'Nombre del padre: '+regmae.nom_ape_p);
        writeln(texto, 'DNI del padre: '+IntToStr(regmae.dni_p));
        writeln(texto, 'Nombre de la madre: '+regmae.nom_ape_m);
        writeln(texto, 'DNI de la madre: '+IntToStr(regmae.dni_m));
        writeln(texto, 'Matricula del médico: '+IntToStr(regmae.matricula_n));
        if(regmae.fallecio='Si') then begin
            writeln(texto, ' ');
            writeln(texto, 'Acta de defunción');
            writeln(texto, '-----------------');
            writeln(texto, 'Matricula del médico: '+IntToStr(regmae.matricula_d));
            writeln(texto, 'Fecha y hora: '+regmae.fecha_hora);
            writeln(texto, 'Lugar: '+regmae.lugar);
        end;
        writeln(texto, ' ')
    end;
    close(mae);
    close(texto);
    ClrScr;
    writeln('Archivo maestro.dat exportado en maestro.txt correctamente!!');
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
                for cont:=1 to cant_sedes do
                    importar('nac', 'sede'+IntToStr(cont));
            end;
            2: begin
                for cont:=1 to cant_sedes do
                    importar('defun', 'sede'+IntToStr(cont));
            end;
            3: begin
                crearMae();
            end;
            4: begin
                for cont:=1 to cant_sedes do
                    cargarAlArchivoMaestro('nac','sede'+IntToStr(cont));
            end;
            5: begin
                for cont:=1 to cant_sedes do
                    cargarAlArchivoMaestro('defun','sede'+IntToStr(cont));
            end;
            6: begin
                exportar('maestro');
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);          
end.