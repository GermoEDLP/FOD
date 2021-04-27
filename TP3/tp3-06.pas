program tp3_6;
uses Crt, sysutils;
const valor_alto = 9999;
type
    str20 = string[20];
    str8 = string[8];
    prenda = record
        cod_prenda: integer;
        desc: str20;
        colores: str20;
        tipo_prenda: str20;
        stock: integer;
        precio_u: real;
    end;
    detalle = file of integer;
    maestro = file of prenda;

procedure leerM(var archivo: maestro; var dato: prenda);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato.cod_prenda := valor_alto;
end;

procedure leerD(var archivo: detalle; var dato: integer);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato := valor_alto;
end;

procedure importarDesdeArchivo(tipo: str8);
var
    mae: maestro;
    det: detalle;
    regm: prenda;
    regd: integer;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'data/ej6/maestro.dat');
            rewrite(mae);
            assign(texto, 'data/ej6/maestro.txt');
            reset(texto);
            while(not eof(texto))do begin
                readln(texto, regm.cod_prenda, regm.desc);
                readln(texto, regm.stock, regm.tipo_prenda);
                readln(texto, regm.precio_u, regm.colores);
                write(mae, regm);
            end;
            close(mae);
            close(texto);
            writeln('Maestro cargado correctamente...');
        end;
        'detalle': begin
            assign(det, 'data/ej6/detalle.dat');
            rewrite(det);
            assign(texto, 'data/ej6/detalle.txt');
            reset(texto);
            while(not eof(texto))do begin
                readln(texto, regd);
                write(det, regd);
            end;
            close(det);
            close(texto);
            writeln('Detalle cargado correctamente...');
        end;
    end;
end;

procedure actualizarMaestro();
var
    mae: maestro;
    det: detalle;
    regm: prenda;
    regd: integer;
begin
    assign(mae, 'data/ej6/maestro.dat');
    reset(mae);
    assign(det, 'data/ej6/detalle.dat');
    reset(det);      
    leerM(mae, regm);
    while(regm.cod_prenda<>valor_alto) do begin
        reset(det);
        leerD(det, regd);
        while(regd<>valor_alto)do begin
            if(regm.cod_prenda=regd) then begin
                regm.stock:=-1;
                seek(mae, filePos(mae)-1);
                write(mae, regm);
            end;
            leerD(det, regd);
        end;
        leerM(mae, regm);
    end;
end;

procedure exportar();
var
    mae: maestro;
    regm: prenda;
    texto: Text;
begin
    assign(mae, 'data/ej6/maestro.dat');
    reset(mae);
    assign(texto, 'data/ej6/maestroActualizado.txt');
    rewrite(texto);
    while(not eof(mae))do begin
        read(mae, regm);
        if(regm.stock>0) then begin
            writeln(texto, regm.cod_prenda, regm.desc);
            writeln(texto, regm.stock, regm.tipo_prenda);
            writeln(texto, regm.precio_u:0:2, regm.colores);
        end;       
    end;
    close(mae);
    close(texto);
end;

begin
    importarDesdeArchivo('maestro');
    writeln('Archivo maestro importado <ENTER>...');
    readln();
    importarDesdeArchivo('detalle');
    writeln('Archivo detalle importado <ENTER>...');
    readln();
    actualizarMaestro();
    writeln('Maestro actualizado <ENTER>...');
    readln();
    exportar();
    writeln('Maestro exportado <ENTER>...');
    readln();
end.