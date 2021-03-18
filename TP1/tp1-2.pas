 program trabajo_practico_1_2;
 type
    archivo = file of longint;

 var
    enteros : archivo;
    entero, total, cant : longint;
    nombre: string[20];
    s: string[100];
    begin
            cant:= 0;
            total:= 0;
            writeln('Por favor ingrese el nombre del archivo a leer: ');
            readln(nombre);
            assign(enteros, 'data/'+ nombre+'.txt');
            reset(enteros);
            
            while (not eof(enteros)) do begin
                Read(enteros, entero);
                writeln(entero);
                total := total + entero;
                cant:= cant +1;
            end;

            writeln('La suma total es: ', total);
            writeln('El promedio de numeros es: ', total/cant:0:2);


            close(enteros);
           
    end.