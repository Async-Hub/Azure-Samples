using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Azure.ServiceBus;

namespace Queue
{
    public partial class Form : System.Windows.Forms.Form
    {
        private IQueueClient _queueClient;

        public Form()
        {
            InitializeComponent();
        }

        private void connectButton_Click(object sender, EventArgs e)
        {
            _queueClient = new QueueClient(connectionStringTextBox.Text, "queue-1");
            connectionStatusLabel.Text = _queueClient.ClientId;
            connectButton.Enabled = false;
            sendMessageButton.Enabled = true;
        }

        private async void sendMessageButton_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(messsageTextBox.Text))
            {
                MessageBox.Show(@"Please enter a text for the message");
            }

            var messagePayload = Encoding.UTF8.GetBytes(messsageTextBox.Text!);
            await _queueClient.SendAsync(new Microsoft.Azure.ServiceBus.Message(messagePayload));
        }
    }
}
