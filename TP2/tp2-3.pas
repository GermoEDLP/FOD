 program tp2_2;
 uses Crt, sysutils;
 const v_a = 9999;
 type
    str20 = string[20];
    producto = record
        cod: integer;
        nombre: str20;
        desc: str20;
        sotck_d: integer;
        stock_m: integer;
        precio: double;
    end;
    venta = record
        cod: integer;
        cant: integer;
    end;
    maestro = file of producto;
    detalle = file of venta;

procedure leer(	var archivo: detalle; var venta: venta);
begin
    if (not(EOF(archivo))) then 
       read (archivo, venta)
    else 
		    venta.cod := v_a;
end;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Crear archivo maestro');
    writeln('2. Crear archivos detalle');
    writeln('3. Actualizar maestro');
    writeln('4. Reporte maestro');
    writeln('5. Reporte stock');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar(tipo: str20);
var
    mae: maestro;
    det: detalle;
    regmae: producto;
    regdet: venta;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'dataEj3/'+tipo+'.dat');
            rewrite(mae);
            assign(texto, 'dataEj3/productos.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regmae.cod, regmae.precio, regmae.nombre);
                readln(texto, regmae.sotck_d, regmae.stock_m, regmae.desc);
                write(mae, regmae);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo productos.txt importado en maestro.dat correctamente!!');
            writeln();
        end;
        else 
            assign(det, 'dataEj3/'+tipo+'.dat');
            rewrite(det);
            assign(texto, 'dataEj3/'+tipo+'.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet.cod, regdet.cant);
                write(det, regdet);
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivo '+tipo+'.txt importado en '+tipo+'.dat correctamente!!');
            writeln();
        
    end;
end;

procedure actualizarArchivoMaestro(detalle: str20);
var
    mae: maestro;
    det: detalle;
    regm: producto;
    regd: venta;
    aux: integer;
    total_vendido: integer;
begin
    assign(mae, 'dataEj3/maestro.dat');
    assign(det, 'dataEj3/'+detalle+'.dat');
    reset(mae);
    reset(det);
    read(mae, regm);
    leer(det, regd);
    while (regd.cod <> v_a) do begin
        aux := regd.cod;
        total_vendido:=0;
        while (aux = regd.cod) do begin
            total_vendido:=total_vendido+regd.cant;
            leer(det, regd);
        end;
        while(regm.cod<>aux)do
            read(mae, regm);
        
        regm.sotck_d:=regm.sotck_d-total_vendido;
        seek(mae, filePos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then 
            read(mae, regm);
    end;
    close(det);
    close(mae);
    ClrScr;
    writeln('Archivo maestro.dat actualizado correctamente en base a '+detalle+'.dat!!');
    writeln();
end;

procedure exportar(tipo: str20);
var
    mae: maestro;
    regmae: producto;
    texto: Text;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'dataEj3/maestro.dat');
            reset(mae);
            assign(texto, 'dataEj3/reporteMaestro.txt');
            rewrite(texto);
            while(not eof(mae)) do begin
                read(mae, regmae);
                writeln(texto, regmae.cod ,' ', regmae.precio:0:2, regmae.nombre);
                writeln(texto, regmae.sotck_d,' ',regmae.stock_m, regmae.desc);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo maestro.dat exportado en reporteAlumnos.txt correctamente!!');
            writeln();   
        end;
        'stock': begin
            assign(mae, 'dataEj3/maestro.dat');
            reset(mae);
            assign(texto, 'dataEj3/reporteStock.txt');
            rewrite(texto);
            while(not eof(mae)) do begin
                read(mae, regmae);
                if(regmae.sotck_d<=regmae.stock_m)then begin
                    writeln(texto, regmae.cod, ' ', regmae.precio:0:2, regmae.nombre);
                    writeln(texto, regmae.sotck_d,' ',regmae.stock_m, regmae.desc);
                end;
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo maestro.dat exportado en reporteAlumnos.txt correctamente!!');
            writeln();   
        end;


    end; 
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
                importar('maestro');
            end;
            2: begin
                for cont:=1 to 3 do
                    importar('detalle'+IntToStr(cont));
            end;
            3: begin
                for cont:=1 to 3 do
                    actualizarArchivoMaestro('detalle'+IntToStr(cont));
            end;
            4: begin
                exportar('maestro');
            end;
            5: begin
                exportar('stock');
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);          
end.