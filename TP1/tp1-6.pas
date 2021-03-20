program tp1_6;
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
    writeln('1. Agregar/Modificar información');
    writeln('2. Exportar');
    writeln('3. Listar');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

function submenuModificar():integer;
var opc: integer;
begin
    writeln('Cargar/Modificar información: ');
    writeln('==================');
    writeln('1. Importar información desde archivo .txt');
    writeln('2. Añadir registros al final del archivo');
    writeln('3. Modificar stock');
    writeln('0. Volver');
    readln(opc);
    submenuModificar:= opc;
end;

function submenuExportar():integer;
var opc: integer;
begin
    writeln('Exportar: ');
    writeln('==================');
    writeln('1. Exportar a archivo .txt');
    writeln('2. Exportar celulares sin stock');
    writeln('0. Volver');
    readln(opc);
    submenuExportar:= opc;
end;

function submenuMostrar():integer;
var opc: integer;
begin
    writeln('Exportar: ');
    writeln('==================');
    writeln('1. Listar celulares con poco stock');
    writeln('2. Listar por filtro');
    writeln('0. Volver');
    readln(opc);
    submenuMostrar:= opc;
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
procedure exportar(archivo: str8; text: str8);
var
    texto: Text;
    celulares: archivo;
    cel: celular;
begin
    assign(celulares, 'data/'+archivo+'.dat');
    reset(celulares);
    assign(texto, 'data/'+text+'.txt');
    rewrite(texto);
    while(not eof(celulares)) do begin
        read(celulares, cel);
        if((text='celular') or (cel.s_disp=0))then begin
            writeln(texto, cel.codigo,' ', cel.precio:0:2, ' ', cel.marca);
            writeln(texto, cel.s_min,' ', cel.s_disp, ' ', cel.desc);
            writeln(texto, cel.nombre);
        end;
    end;
    writeln('Archivo exportado con exito...');
    close(celulares);
    close(texto);
end;

function agregarCelular():celular;
var
    cel: celular;
begin
    writeln();
    writeln('Celular (código): ');
    readln(cel.codigo);
    writeln('Marca: ');
    readln(cel.marca);
    writeln('Modelo: ');
    readln(cel.nombre);
    writeln('Descripción: ');
    readln(cel.desc);
    writeln('Precio: $');
    readln(cel.precio);
    writeln('Stock Min.: ');
    readln(cel.s_min);
    writeln('Stock Disp.: ');
    readln(cel.s_disp);
    agregarCelular:=cel;
end;

procedure modificar(archivo: str8; tipo: str8);
var 
    celulares: archivo;
    cel: celular;
    add: char;
    filter: str20;
    stock: integer;
begin
    assign(celulares, 'data/'+archivo+'.dat');
    reset(celulares);
    case tipo of
        'add': begin
            seek(celulares, fileSize(celulares));
            writeln('Desea agregar un celular (s/n): ');
            readln(add);
            while(add='s')do begin
                cel := agregarCelular();
                write(celulares, cel);
                writeln('Desea agregar otro celular (s/n): ');
                readln(add);
            end;
        end;
        'stock': begin
            writeln('Indique el nombre celular: ');
            readln(filter);
            while(not eof(celulares)) do begin
                read(celulares, cel);
                if(Pos(filter, cel.nombre)<>0) then begin                                       
                    writeln('Marca: ', cel.marca, ' | Modelo: ', cel.nombre);
                    writeln('Stock actual: ', cel.s_disp);
                    writeln('Indique el nuevo stock: ');
                    readln(stock);
                    cel.s_disp := stock;
                    seek(celulares, filePos(celulares)-1);
                    write(celulares, cel);
                end;
            end;
        end;
    end;


    close(celulares);

end;

var
    celulares: archivo;
    cel: celular;
    opc, subopc: integer;
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
                subopc:= submenuModificar();
                case subopc of
                    1: begin
                        ClrScr;
                        importarTxt(archivo_nombre);
                    end;
                    2: begin
                        ClrScr;
                        modificar(archivo_nombre, 'add');
                    end;
                    3: begin
                        ClrScr;
                        modificar(archivo_nombre, 'stock');
                    end;
                end;
            end;
            2: begin
                subopc:= submenuExportar();
                case subopc of
                    1: begin
                        ClrScr;
                        exportar(archivo_nombre, 'celular');
                    end;
                    2: begin
                        ClrScr;
                        exportar(archivo_nombre, 'sinStock')
                    end;
                end;               
            end;
            3: begin
                subopc:= submenuMostrar();
                case subopc of
                    1: begin
                        ClrScr;
                        listarCelulares(archivo_nombre, 'stock');
                    end;
                    2: begin
                        ClrScr;
                        listarCelulares(archivo_nombre, 'filter');
                    end;
                end;               
            end;
            0: begin
                fin:= true;
            end;
        end;
    until(fin);
end.