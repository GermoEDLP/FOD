 program tp2_5;
 uses Crt, sysutils;
 const v_a = 9999;
 type
    str20 = string[20];
    producto = record
        cod: integer;
        nombre: str20;
        stock_d: integer;
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
    writeln('1. Crear archivo maestro a partir de un productos.txt');
    writeln('2. Crear archivo reporte.txt en base al maestro');
    writeln('3. Crear archivo detalle a partir de ventas.txt');
    writeln('4. Ver ventas (acumuladas)');
    writeln('5. Actualizar maestro en base a detalle');
    writeln('6. Reporte stock');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar(carpeta: str20);
var
    mae: maestro;
    det: detalle;
    regmae: producto;
    regdet: venta;
    texto: Text;
begin
    case carpeta of
        'maestro': begin
            assign(mae, 'dataEj7/productos/maestro.dat');
            rewrite(mae);
            assign(texto, 'dataEj7/productos/productos.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regmae.cod, regmae.stock_d, regmae.stock_m, regmae.precio, regmae.nombre);
                write(mae, regmae);
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo de productos importado correctamente!!');
            writeln();
        end;
        'detalle': begin
            assign(det, 'dataEj7/ventas/ventas.dat');
            rewrite(det);
            assign(texto, 'dataEj7/ventas/ventas.txt');
            reset(texto);
            while(not eof(texto)) do begin
                readln(texto, regdet.cod, regdet.cant);
                write(det, regdet);
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivos de ventas importado correctamente!!');
            writeln();
        end;
        
    end;
end;

procedure listar();
var
    det: detalle;
    regdet: venta;
    aux, cant:integer;
begin
    assign(det, 'dataEj7/ventas/ventas.dat');
    reset(det);
    writeln('Reporte de ventas');
    writeln('-----------------');
    writeln(' ');
    leer(det, regdet);
    while(regdet.cod<>v_a) do begin
        aux:= regdet.cod;
        cant:=0;
        while(regdet.cod=aux) do begin
            cant:=cant+regdet.cant;
            leer(det, regdet);
        end;
        writeln('Producto: ' +IntToStr(aux)+ ' | Cantidad: '+ IntToStr(cant));
    end;
    close(det);
end;


procedure actualizarArchivoMaestro();
var
    mae: maestro;
    det: detalle;
    regm: producto;
    regd: venta;
    aux: integer;
    total_vendido: integer;
begin
    assign(mae, 'dataEj7/productos/maestro.dat');
    assign(det, 'dataEj7/ventas/ventas.dat');
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
        regm.stock_d:=regm.stock_d-total_vendido;
        seek(mae, filePos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then begin
            read(mae, regm);
        end;
    end;
    close(det);
    close(mae);
end;

procedure exportar(tipo: str20);
var
    mae: maestro;
    regmae: producto;
    det: detalle;
    regdet: venta;
    texto: Text;
    aux: integer;
    cant:integer;
begin
    case tipo of
        'maestro': begin
            assign(mae, 'dataEj7/productos/maestro.dat');
            reset(mae);
            assign(texto, 'dataEj7/informes/reporte.txt');
            rewrite(texto);
            writeln(texto, 'Reporte de productos');
            writeln(texto, '--------------------');
            writeln(texto, ' ');
            while(not eof(mae)) do begin
                read(mae, regmae);
                writeln(texto, 'Codigo: ', regmae.cod, ' | Producto:', regmae.nombre, ' | Precio: ', regmae.precio:0:2, ' | Stock disp.: ',regmae.stock_d,' Stock min.: ',regmae.stock_m);
                writeln(texto, ' ');
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo maestro.dat exportado en reporte.txt correctamente!!');
            writeln();   
        end;
        'detalle': begin
            assign(det, 'dataEj7/ventas/ventas.dat');
            reset(det);
            assign(texto, 'dataEj7/informes/reporteDetalle.txt');
            rewrite(texto);
            writeln(texto, 'Reporte de ventas');
            writeln(texto, '-----------------');
            writeln(texto, ' ');
            leer(det, regdet);
            while(regdet.cod<>v_a) do begin
                read(det, regdet);
                aux:= regdet.cod;
                cant:=0;
                while(regdet.cod=aux) do begin
                    cant:=cant+regdet.cant;
                    leer(det, regdet);
                end;
                writeln(texto, 'Producto: ' +IntToStr(aux)+ ' | Cantidad: '+ IntToStr(cant));
            end;
            close(det);
            close(texto);
            ClrScr;
            writeln('Archivo reporte.txt fue creado correctamente!!');
            writeln();   
        end;
        'stock': begin
            assign(mae, 'dataEj7/productos/maestro.dat');
            reset(mae);
            assign(texto, 'dataEj7/informes/stock.txt');
            rewrite(texto);
            writeln(texto, 'Productos debajo del Stock de seguridad');
            writeln(texto, '---------------------------------------');
            writeln(texto, ' ');
            while(not eof(mae)) do begin
                read(mae, regmae);
                if(regmae.stock_d<=regmae.stock_m)then begin
                    writeln(texto, 'Codigo: ', regmae.cod); 
                    writeln(texto, 'Producto:', regmae.nombre, ' | Precio: ', regmae.precio:0:2);
                    writeln(texto, 'Stock disp.: ',regmae.stock_d,' Stock min.: ',regmae.stock_m);
                    writeln(texto, ' ');
                end;
            end;
            close(mae);
            close(texto);
            ClrScr;
            writeln('Archivo maestro.dat exportado en stock.txt correctamente!!');
            writeln();   
        end;


    end; 
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
                exportar('maestro');
            end;
            3: begin
                importar('detalle');
            end;
            4: begin
                listar();
            end;
            5: begin
                actualizarArchivoMaestro()
            end;
            6: begin
                exportar('stock');
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);          
end.