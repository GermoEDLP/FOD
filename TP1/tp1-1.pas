 program trabajo_practico_1_1;
 type
    archivo = file of longint;

 var
    enteros : archivo;
    entero : longint;
    nombre: string[20];
    s: string[100];
    begin
            writeln('Por favor ingrese el nombre del archivo a crear: ');
            readln(nombre);
            GetDir(0, s);
            // writeln(s+ '/data/' + nombre+'.txt');
            assign(enteros, 'data/'+ nombre+'.txt');
            rewrite(enteros);
            writeln('Ingrese un numero para almacenar: ');
            readln(entero);
            while (entero <> 300000) do begin
                write(enteros, entero);
                writeln('Ingrese un numero para almacenar: ');
                readln(entero);
            end;

            close(enteros);
           
    end.