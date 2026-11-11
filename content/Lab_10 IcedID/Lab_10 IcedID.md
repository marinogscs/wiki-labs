---
title: "Lab 10 · IcedID"
---
## Caso IcedID

>Se identificó un grupo de amenazas cibernéticas por iniciar campañas de phishing generalizadas para distribuir más cargas maliciosas. Las cargas más frecuentes eran IcedID. Se le ha proporcionado un hash de una muestra de IcedID para analizar y supervisar las actividades de este grupo de Amenaza Persistente Avanzada (APT).

### Q1/ ¿Cuál es el nombre del archivo asociado al hash dado?

>Para encontrar el nombre relacionado con el hash usaremos la herramienta web VirusTotal, en la cual introduciremos el hash. Una vez hecho esto en el apartado de detalles encontraremos el nombre.

![Captura1](Lab_10%20IcedID/Capturas/Captura1.png)

### Q2/ ¿Puedes identificar el nombre del archivo GIF que se implementó?

>Para encontrar el nombre del archivo **GIF** nos dirigimos al apartado de **Relations** en VirusTotal, y bajando encontramos **Dropped files** donde encontraremos el nombre.

![Captura2](Lab_10%20IcedID/Capturas/Captura2.png)

### Q3/ ¿Cuántos dominios busca el malware para descargar el archivo de carga útil adicional en el Q2?

>En el apartado de **Relations** de VirusTotal podemos encontrar la cantidad de dominios que busca el malware siendo **5**.

![Captura3](Lab_10%20IcedID/Capturas/Captura3.png)

### Q4/ De los dominios mencionados en la pregunta 3, el autor de la amenaza utilizó principalmente un registrador DNS para alojar su contenido malicioso, lo que permitió el funcionamiento del malware. ¿Puede especificar el nombre del registrador INC?

>En el apartado de **Relations** de VirusTotal podemos encontrar el nombre del registrador INC siendo este **NameCheap INC**.

![Captura4](Lab_10%20IcedID/Capturas/Captura4.png)

### Q5/ ¿Podría especificar quién es el autor de la amenaza vinculado a la muestra proporcionada?

>Para encontrar el autor de la amenaza vinculado usamos la página de MITRE ATT&CK y buscamos el malware **IcedID** y encontraremos bastante información sobre él y lo que buscamos, vemos que el nombre es **GOLD CABIN**.

![Captura5](Lab_10%20IcedID/Capturas/Captura5.png)

### Q6/ En la fase de ejecución, ¿qué función emplea el malware para introducir cargas útiles adicionales en el sistema?

>Para encontrar la función tenemos que buscar el código del malware y para eso utilizaré una página llamada Triage esta herramienta nos permite ver el código y vemos que la función que usó es **URLDownloadToFileA**

![Captura6](Lab_10%20IcedID/Capturas/Captura6.png)



![Captura7](Lab_10%20IcedID/Capturas/Captura7.png)

Siguiente Write-up: [[Lab_11 FakeGPT]]