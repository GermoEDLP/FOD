 program tp3_2;
 uses Crt, sysutils;
 type
    str20 = string[20];
    str8 = string[8];
    empleado = record
        nomyape: str20;
        tel: str20;
        dni: longint;
        n_emp: integer;
        fecha: str20;
        direc: str20;
    end;
    archivo = file of empleado;

procedure crearEmpleados();
var 
    empleados: archivo; 
    emp: empleado; 
    texto: Text;
begin
    assign(empleados, 'data/ej2/empleados.dat');
    rewrite(empleados);
    assign(texto, 'data/ej2/empleados.txt');
    reset(texto);
    while(not eof(texto)) do begin
        readln(texto, emp.n_emp, emp.nomyape);
        readln(texto, emp.dni, emp.direc);
        readln(texto, emp.tel);
        readln(texto, emp.fecha);
        write(empleados, emp);
    end;
    close(texto);
    close(empleados);
    ClrScr;
end;

procedure imprimirEmpleado(emp: empleado);
begin
    writeln('Empleado #', emp.n_emp, ': ');
    writeln('===============');
    writeln('Apellido y nombre: '+emp.nomyape);
    writeln('DNI: '+IntToStr(emp.dni));
    writeln('Fecha de nacimiento: ',emp.fecha);
    writeln('Dirección: ',emp.direc);
    writeln('Telefono: ',emp.tel);
    writeln();
end;

procedure listarEmpleados();
var 
    empleados: archivo;
    emp: empleado;
begin
    assign(empleados, 'data/ej2/empleados.dat');
    reset(empleados);
    ClrScr;
    if (eof(empleados)) then begin 
        writeln('No hay empleados en la BD.');
    end;
    while (not eof(empleados)) do begin
        Read(empleados, emp);
        imprimirEmpleado(emp);
    end;
    close(empleados);  
end;

procedure borrarEmpleados();
var 
    empleados: archivo;
    emp: empleado;
begin
    assign(empleados, 'data/ej2/empleados.dat');
    reset(empleados);
    ClrScr;
    if (eof(empleados)) then begin 
        writeln('No hay empleados en la BD.');
    end;
    while (not eof(empleados)) do begin
        Read(empleados, emp);
        if(emp.dni<8000000) then begin
            emp.nomyape := '*'+emp.nomyape;
            seek(empleados, filePos(empleados)-1);
            write(empleados, emp);
        end;
    end;
    close(empleados);  
end;


begin
    crearEmpleados();
    writeln('Archibo binario de empleados, creado correctamente...<ENTER>');
    readln();
    listarEmpleados();
    writeln('Empleados impresos correctamente...<ENTER>');
    readln();
    borrarEmpleados();
    writeln('Empleados borrados correctamente...<ENTER>');
    readln();
    listarEmpleados();
    writeln('Empleados impresos correctamente...<ENTER>');
    readln();
end.