#include "servercomm.h"
#include "playlistreader.h"
#include <QDebug>
#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QMediaPlaylist>
#include <QTimer>
#include <QDomDocument>

ServerComm::ServerComm(QObject *parent) :
    QObject(parent)
{
    m_progress = 0;

    playlistNetworkReader = new QNetworkAccessManager(this);
    connect(playlistNetworkReader, SIGNAL(finished(QNetworkReply*)), this, SLOT(finishLoadingChannel(QNetworkReply*)));

    channelInfoReader = new QNetworkAccessManager(this);
    connect(channelInfoReader, SIGNAL(finished(QNetworkReply*)), this, SLOT(finishReadingChannelInfo(QNetworkReply*)));

    player = new QMediaPlayer(this);
    mediaplaylist = new QMediaPlaylist;
    player->setPlaylist(mediaplaylist);
    player->setNotifyInterval(1000); // Only emit signal once every second. Should save some battery

    connect(player, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)), this, SLOT(setMediaStatus(QMediaPlayer::MediaStatus)));
    connect(player, SIGNAL(positionChanged(qint64)), this, SLOT(setProgress(qint64)));

    connect(player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(playerState(QMediaPlayer::State)));

    nowPlayingSongTimer = new QTimer(this);
    connect(nowPlayingSongTimer, SIGNAL(timeout()), this, SIGNAL(updateSong()));
}

void ServerComm::play()
{
    player->play();
}

void ServerComm::pause()
{
    player->pause();
}

void ServerComm::loadChannel(QString channelUrl)
{
    setChannelLoading(true);
    playlistNetworkReader->get(QNetworkRequest(channelUrl));
}

void ServerComm::finishLoadingChannel(QNetworkReply *reply)
{
    QByteArray playlistData = reply->readAll();
    PlaylistReader playlistReader(playlistData);
    PlaylistReader::StreamUrls streamUrls = playlistReader.getStreamUrls();

    QString streamUrl = streamUrls[0];
    mediaplaylist->clear();
    mediaplaylist->addMedia(QUrl(streamUrl));

    player->play();
}

void ServerComm::setMediaStatus(QMediaPlayer::MediaStatus state)
{
    switch (state) {
    case QMediaPlayer::BufferingMedia:
        setChannelLoading(true);
        break;
    case QMediaPlayer::BufferedMedia:
        setChannelLoading(false);
        break;
    case QMediaPlayer::LoadingMedia:
        setChannelLoading(true);
        break;
    case QMediaPlayer::StalledMedia:
        setChannelLoading(true);
        break;
    default:
        break;
    }
}

void ServerComm::checkSongUpdates()
{
    updateSong();
}

void ServerComm::playerState(QMediaPlayer::State state)
{
    switch (state)
    {
        case QMediaPlayer::StoppedState:
            nowPlayingSongTimer->stop();
            setPlaying(false);
            break;
        case QMediaPlayer::PlayingState:
            nowPlayingSongTimer->start(SONGS_POLL_TIME);
            setPlaying(true);
            break;
        case QMediaPlayer::PausedState:
            nowPlayingSongTimer->stop();
            setPlaying(false);
            break;
    }
}

void ServerComm::updateChannelInfo(QString channelId)
{
    QNetworkRequest request = QNetworkRequest(QUrl(CHANNEL_REFRESH_URL));
    request.setAttribute(QNetworkRequest::User, QVariant(channelId));
    channelInfoReader->get(request);
}

void ServerComm::finishReadingChannelInfo(QNetworkReply *reply)
{
    QString channelId = reply->request().attribute(QNetworkRequest::User).toString();
    QString lastPlaying = "";

    QByteArray data = reply->readAll();
    QString xmldata = QString::fromUtf8(data);

    QDomDocument doc("Channels");
    doc.setContent(xmldata.toUtf8());

    QDomNodeList channels = doc.documentElement().elementsByTagName("channels").at(1).toElement().elementsByTagName("channel");

    for(int i = 0; i < channels.count(); i++)
    {
        if(channels.at(i).toElement().attribute("id") == channelId)
            lastPlaying = channels.at(i).toElement().elementsByTagName("lastPlaying").at(0).toElement().text();
    }

    setLastPlaying(lastPlaying);
}

bool ServerComm::isPlaying() { return m_playing; }
void ServerComm::setPlaying(bool playing)
{
    if (m_playing != playing) {
        m_playing = playing;
        emit playingChanged();
    }
}

bool ServerComm::isChannelLoading() { return m_channelLoading; }
void ServerComm::setChannelLoading(bool loading)
{
    if (m_channelLoading != loading) {
        m_channelLoading = loading;
        emit channelLoadingChanged();
    }
}

QString ServerComm::lastPlaying() { return m_lastPlaying; }
void ServerComm::setLastPlaying(QString lastPlaying)
{
    if (m_lastPlaying != lastPlaying) {
        m_lastPlaying = lastPlaying;
        emit lastPlayingChanged();
    }
}

qint64 ServerComm::progress() { return m_progress; }
void ServerComm::setProgress(qint64 time)
{
    if (m_progress != time) {
        m_progress = time;
        emit progressChanged();
    }
}
