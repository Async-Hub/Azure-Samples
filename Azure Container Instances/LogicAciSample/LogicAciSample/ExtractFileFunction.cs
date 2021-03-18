using Azure.Storage.Blobs;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.IO.Compression;
using System.Threading.Tasks;

namespace LogicAciSample
{
    public static class ExtractFileFunction
    {
        private static bool _isInProcess = false;

        [FunctionName("ExtractFileFunction")]
        public static async Task Run([TimerTrigger("*/5 * * * * *")]TimerInfo myTimer, 
            IBinder binder, ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

            if(_isInProcess) return;

            _isInProcess = true;
            var blobContainerClient = await binder.BindAsync<BlobContainerClient>
                (new BlobAttribute("7dfc6797-5a95-434c-898a-3e44c3a2c51a"));

            try
            {
                var resultSegment = blobContainerClient.GetBlobsAsync();

                // Enumerate the blobs returned for each page.
                await foreach (var blobItem in resultSegment)
                {
                    if (!blobItem.Name.Contains(".zip")) continue;

                    var blobClient = blobContainerClient.GetBlobClient(blobItem.Name);
                    var memoryStream = new MemoryStream();
                    await blobClient.DownloadToAsync(memoryStream);

                    await UploadBlobAsync(memoryStream, blobContainerClient);
                }
            }
            catch (Exception e)
            {
                log.LogError(e.Message, e);
            }

            _isInProcess = false;
        }

        private static async Task UploadBlobAsync(Stream zippedStream, BlobContainerClient blobContainerClient)
        {
            using var archive = new ZipArchive(zippedStream);

            foreach (var archiveEntry in archive.Entries)
            {
                await using var unzippedEntryStream = archiveEntry.Open();
                await using var memoryStream = new MemoryStream();
                await unzippedEntryStream.CopyToAsync(memoryStream);
                memoryStream.Position = 0;
                await blobContainerClient.UploadBlobAsync(archiveEntry.Name, memoryStream);
            }
        }
    }
}
