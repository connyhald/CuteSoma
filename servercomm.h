#ifndef SERVERCOMM_H
#define SERVERCOMM_H

#include <QObject>
#include <QString>
#include <QMediaPlayer>

class QNetworkAccessManager;
class QNetworkReply;
class QMediaPlaylist;
class QTimer;

#define SONGS_POLL_TIME 10000
#define CHANNEL_REFRESH_URL "http://somafm.com/refresh.xml"

class ServerComm : public QObject
{
    Q_OBJECT

    Q_PROPERTY (bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY (bool channelLoading READ isChannelLoading NOTIFY channelLoadingChanged)
    Q_PROPERTY (QString lastPlaying READ lastPlaying NOTIFY lastPlayingChanged)
    Q_PROPERTY (qint64 progress READ progress NOTIFY progressChanged())

public:
    explicit ServerComm(QObject *parent = 0);

    bool isPlaying();
    void setPlaying(bool playing);

    bool isChannelLoading();
    void setChannelLoading(bool loading);

    QString lastPlaying();
    void setLastPlaying(QString lastPlaying);

    qint64 progress();
    //void setProgress(qint64 time);

private:
    QNetworkAccessManager *playlistNetworkReader;
    QNetworkAccessManager *channelInfoReader;
    QMediaPlayer *player;
    QMediaPlaylist *mediaplaylist;
    QTimer *nowPlayingSongTimer;
    bool m_playing;
    bool m_channelLoading;
    QString m_lastPlaying;
    qint64 m_progress;

signals:
    void playingChanged();
    void channelLoadingChanged();
    void lastPlayingChanged();
    void progressChanged();
    void updateSong();

public slots:
    void play();
    void pause();
    void loadChannel(QString channelUrl);
    void updateChannelInfo(QString channelName);

private slots:
    void setProgress(qint64 time);

protected slots:
    void finishLoadingChannel(QNetworkReply *reply);
    void finishReadingChannelInfo(QNetworkReply *reply);
    void setMediaStatus(QMediaPlayer::MediaStatus state);
    void checkSongUpdates();
    void playerState(QMediaPlayer::State state);
};

#endif // SERVERCOMM_H
