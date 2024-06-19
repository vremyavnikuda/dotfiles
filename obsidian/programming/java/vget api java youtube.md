#java #medianamager #vgetapi[[MediaManager]]
api vget позволит подключить скачивание ресурсов с youtube по прямой ссылке 

пример прямой  загрузки 
```java
package com.github.axet.vget;

import java.io.File;
import java.net.URL;

public class Example {

    public static void main(String[] args) {
        try {
            VGet v = new VGet(new URL("http://vimeo.com/52716355"), new File("/Users/axet/Downloads"));
            v.download();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
```

Пример управляемой загрузки из приложения 
```java
package com.github.axet.vget;

import java.io.File;
import java.net.URL;
import java.util.concurrent.atomic.AtomicBoolean;

import com.github.axet.vget.info.VideoInfo;
import com.github.axet.wget.info.DownloadInfo;
import com.github.axet.wget.info.DownloadInfo.Part;
import com.github.axet.wget.info.DownloadInfo.Part.States;

public class Example {

    VideoInfo info;
    long last;

    public void run() {
        try {
            AtomicBoolean stop = new AtomicBoolean(false);
            Runnable notify = new Runnable() {
                @Override
                public void run() {
                    VideoInfo i1 = info;
                    DownloadInfo i2 = i1.getInfo();

                    // notify app or save download state
                    // you can extract information from DownloadInfo info;
                    switch (i1.getState()) {
                    case EXTRACTING:
                    case EXTRACTING_DONE:
                    case DONE:
                        System.out.println(i1.getState());
                        break;
                    case RETRYING:
                        System.out.println(i1.getState() + " " + i1.getDelay());
                        break;
                    case DOWNLOADING:
                        long now = System.currentTimeMillis();
                        if (now - 1000 > last) {
                            last = now;

                            String parts = "";

                            for (Part p : i2.getParts()) {
                                if (p.getState().equals(States.DOWNLOADING)) {
                                    parts += String.format("Part#%d(%.2f) ", p.getNumber(),
                                            p.getCount() / (float) p.getLength());
                                }
                            }

                            System.out.println(String.format("%s %.2f %s", i1.getState(),
                                    i2.getCount() / (float) i2.getLength(), parts));
                        }
                        break;
                    default:
                        break;
                    }
                }
            };

            info = new VideoInfo(new URL("http://vimeo.com/52716355"));

            VGet v = new VGet(info, new File("/Users/axet/Downloads"));

            // optional. only if you dlike to get video title before start
            // download
            v.extract(stop, notify);
            System.out.println(info.getTitle());

            v.download(stop, notify);
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) {
        Example e = new Example();
        e.run();
    }
}
```

Зависимость для maven репозитория 

```pom
<dependency>
  <groupId>com.github.axet</groupId>
  <artifactId>vget</artifactId>
  <version>1.0.40</version>
</dependency>
```
