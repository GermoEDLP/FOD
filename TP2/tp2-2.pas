 program tp2_2;
 uses Crt;
 const v_a = 9999;
 type
    str20 = string[20];
    alumno = record
        cod: integer;
        nombre: str20;
        apellido: str20;
        cursadas: integer;
        final: integer;
    end;
    acta = record
        cod: integer;
        estado: str20;
    end;
    maestro = file of alumno;
    detalle = file of acta;

procedure leer(	var archivo: detalle; var acta: acta);
begin
    if (not(EOF(archivo))) then 
       read (archivo, acta)
    else 
		    acta.cod := v_a;
end;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Crear archivo maestro');
    writeln('2. Crear archivo detalle');
    writeln('3. Listar archivo maestro');
    writeln('4. Listar archivo detalle');
    writeln('5. Actualizar archivo maestro');
    writeln('6. Listar alumnos con 4 materias');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar(tipo: str20);
var
    mae: maestro;
    det: detalle;
    regmae: alumno;
    regdet: acta;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'data/maestro.dat');
            rewrite(mae);
            assign(texto, 'data/alumnos.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regmae.cod, regmae.apellido);
                readln(texto, regmae.cursadas, regmae.final, regmae.nombre);
                write(mae, regmae);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo alumnos.txt importado en maestro.dat correctamente!!');
            writeln();
        end;
        'detalle': begin
            assign(det, 'data/detalle.dat');
            rewrite(det);
            assign(texto, 'data/detalle.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet.cod, regdet.estado);
                write(det, regdet);
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivo detalle.txt importado en detalle.dat correctamente!!');
            writeln();
        end;
    end;
end;

procedure actualizarArchivoMaestro();
var
    mae: maestro;
    det: detalle;
    regm: alumno;
    regd: acta;
    aux: integer;
    finalAux: integer;
    cursadaAux: integer;
begin
    assign(mae, 'data/maestro.dat');
    assign(det, 'data/detalle.dat');
    reset(mae);
    reset(det);
    read(mae, regm);
    leer(det, regd);
    while (regd.cod <> v_a) do begin
        aux := regd.cod;
        finalAux:=0;
        cursadaAux:=0;
        while (aux = regd.cod) do begin
            if(regd.estado=' cursada') then begin
                cursadaAux:=cursadaAux+1;
            end        
            else begin
                finalAux:=finalAux+1;
            end;
            leer(det, regd);
        end;
        while(regm.cod<>aux)do
            read(mae, regm);
        
        regm.cursadas:=regm.cursadas+cursadaAux;
        regm.final:=regm.final+finalAux;
        seek(mae, filePos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then 
            read(mae, regm);
    end;
    close(det);
    close(mae);
    ClrScr;
    writeln('Archivo maestro.dat actualizado correctamente en base a detalle.dat!!');
    writeln();
end;

procedure exportar(tipo: str20);
var
    mae: maestro;
    det: detalle;
    regmae: alumno;
    regdet: acta;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'data/maestro.dat');
            reset(mae);
            assign(texto, 'data/reporteAlumnos.txt');
            rewrite(texto);
            while(not eof(mae)) do begin
                read(mae, regmae);
                writeln(texto, regmae.cod , regmae.apellido);
                writeln(texto, regmae.cursadas,' ',regmae.final,regmae.nombre);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo maestro.dat exportado en reporteAlumnos.txt correctamente!!');
            writeln();
        end;
        'detalle': begin
            assign(det, 'data/detalle.dat');
            reset(det);
            assign(texto, 'data/reporteDetalle.txt');
            rewrite(texto);
            while(not eof(det)) do begin
                read(det, regdet);
                writeln(texto, regdet.cod, regdet.estado);
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivo detalle.dat exportado en reporteDetalle.txt correctamente!!');
            writeln();
        end;
    end;
end;

procedure listar();
var
    mae: maestro;
    regmae: alumno;
    texto: Text;
begin
    assign(mae, 'data/maestro.dat');
    reset(mae);
    assign(texto, 'data/alumnosCon4Aprobadas.txt');
    rewrite(texto);
    while(not eof(mae)) do begin
        read(mae, regmae);
        if((regmae.cursadas-regmae.final)>=4)then begin
            writeln(texto, regmae.cod , regmae.apellido);
            writeln(texto, regmae.cursadas,' ',regmae.final,regmae.nombre);
        end;
    end;
    close(mae);
    close(texto);
    ClrScr;
    writeln('Archivo maestro.dat filtrado y exportado en alumnosCon4Aprobadas.txt correctamente!!');
    writeln();
end;


var
    fin: boolean;
    opc: integer;
begin
    fin:=false;
    ClrScr;
    repeat
        opc:= menu();
        case opc of
            1: begin
                importar('maestro');
            end;
            2: begin
                importar('detalle');
            end;
            3: begin
                exportar('maestro');
            end;
            4: begin
                exportar('detalle');
            end;
            5: begin
                actualizarArchivoMaestro();            
            end;
            6: begin
                listar();
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);          
end.
