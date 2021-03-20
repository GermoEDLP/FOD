program tp1_5;
 uses Crt;
 type
    str20 = string[20];
    str8 = string[8];
    celular = record
        codigo: integer;
        nombre: str20;
        desc: str20;
        marca: str20;
        precio: real;
        s_min: integer;
        s_disp: integer;
    end;
    archivo = file of celular;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Importar información desde archivo .txt');
    writeln('2. Listar celulares con bajo stock');
    writeln('3. Listar por filtro');
    writeln('4. Exportar');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure imprimirCelular(cel: celular);
begin
    writeln();
    writeln('Celular #', cel.codigo, ': ');
    writeln('===============');
    writeln('Marca: '+cel.marca);
    writeln('Modelo: '+cel.nombre);
    writeln('Descripción: ',cel.desc);
    writeln('Precio: $',cel.precio:0:2);
    writeln('Stock Min.: ',cel.s_min);
    writeln('Stock Disp.: ',cel.s_disp);
    writeln();
end;

procedure importarTxt(archivo: str8);
var 
    texto: Text;
    celulares: archivo;
    cel: celular;
begin
    assign(texto, 'data/carga.txt');
    assign(celulares, 'data/'+archivo+'.dat');
    rewrite(celulares);
    reset(texto);
    while(not eof(texto)) do begin
        readln(texto, cel.codigo, cel.precio, cel.marca);
        readln(texto, cel.s_min, cel.s_disp, cel.desc);
        readln(texto, cel.nombre);
        write(celulares, cel);
    end;
    writeln('Archivo importado con exito...');
    close(celulares);
    close(texto);
end;
procedure listarCelulares(archivo: str8; tipo: str8);
var
    celulares: archivo;
    cel: celular;
    filter: str20;
begin
    assign(celulares, 'data/'+archivo+'.dat');
    reset(celulares);
    case tipo of
        'stock': begin
            while (not eof(celulares)) do begin
                read(celulares, cel);
                if(cel.s_disp < cel.s_min) then begin
                    imprimirCelular(cel);
                end;
            end;
        end;
        'filter': begin
            writeln('Ingrese el parametro a buscar en la descripción: ');
            readln(filter);
            while (not eof(celulares)) do begin
                read(celulares, cel);                
                if(Pos(filter, cel.desc)<>0) then begin
                    imprimirCelular(cel);
                end;
            end;
        end;
    end;


end;
procedure exportar(archivo: str8);
var
    texto: Text;
    celulares: archivo;
    cel: celular;
begin
    assign(texto, 'data/celular.txt');
    assign(celulares, 'data/'+archivo+'.dat');
    rewrite(texto);
    reset(celulares);
     while(not eof(celulares)) do begin
        read(celulares, cel);
        writeln(texto, cel.codigo,' ', cel.precio:0:2, cel.marca);
        writeln(texto, cel.s_min,' ', cel.s_disp, cel.desc);
        writeln(texto, cel.nombre);
    end;
    writeln('Archivo exportado con exito...');
    close(celulares);
    close(texto);
end;

var
    celulares: archivo;
    cel: celular;
    opc: integer;
    archivo_nombre: str20;
    fin: boolean;
    texto: Text;
begin
    fin:=false;
    // writeln('Ingrese el nombre del archivo a trabajar: ');
    // readln(archivo_nombre);
    archivo_nombre:='datosEj5';
    repeat
        opc:= menu();
        case opc of
            1: begin
                importarTxt(archivo_nombre);
            end;
            2: begin
                ClrScr;
                listarCelulares(archivo_nombre, 'stock');
            end;
            3: begin
                ClrScr; 
                listarCelulares(archivo_nombre, 'filter');
            end;
            4: begin
                exportar(archivo_nombre);
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);
end.