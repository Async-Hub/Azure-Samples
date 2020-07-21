namespace Queue
{
    partial class Form
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.messsageTextBox = new System.Windows.Forms.TextBox();
            this.connectButton = new System.Windows.Forms.Button();
            this.sendMessageButton = new System.Windows.Forms.Button();
            this.connectionStatusLabel = new System.Windows.Forms.Label();
            this.connectionStringTextBox = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // messsageTextBox
            // 
            this.messsageTextBox.Location = new System.Drawing.Point(12, 94);
            this.messsageTextBox.Multiline = true;
            this.messsageTextBox.Name = "messsageTextBox";
            this.messsageTextBox.Size = new System.Drawing.Size(776, 151);
            this.messsageTextBox.TabIndex = 0;
            // 
            // connectButton
            // 
            this.connectButton.Location = new System.Drawing.Point(713, 415);
            this.connectButton.Name = "connectButton";
            this.connectButton.Size = new System.Drawing.Size(75, 23);
            this.connectButton.TabIndex = 1;
            this.connectButton.Text = "Connect";
            this.connectButton.UseVisualStyleBackColor = true;
            this.connectButton.Click += new System.EventHandler(this.connectButton_Click);
            // 
            // sendMessageButton
            // 
            this.sendMessageButton.Enabled = false;
            this.sendMessageButton.Location = new System.Drawing.Point(632, 415);
            this.sendMessageButton.Name = "sendMessageButton";
            this.sendMessageButton.Size = new System.Drawing.Size(75, 23);
            this.sendMessageButton.TabIndex = 2;
            this.sendMessageButton.Text = "Send Message";
            this.sendMessageButton.UseVisualStyleBackColor = true;
            this.sendMessageButton.Click += new System.EventHandler(this.sendMessageButton_Click);
            // 
            // connectionStatusLabel
            // 
            this.connectionStatusLabel.AutoSize = true;
            this.connectionStatusLabel.Location = new System.Drawing.Point(12, 9);
            this.connectionStatusLabel.Name = "connectionStatusLabel";
            this.connectionStatusLabel.Size = new System.Drawing.Size(79, 15);
            this.connectionStatusLabel.TabIndex = 3;
            this.connectionStatusLabel.Text = "Disconnected";
            // 
            // connectionStringTextBox
            // 
            this.connectionStringTextBox.Location = new System.Drawing.Point(12, 27);
            this.connectionStringTextBox.Multiline = true;
            this.connectionStringTextBox.Name = "connectionStringTextBox";
            this.connectionStringTextBox.Size = new System.Drawing.Size(776, 61);
            this.connectionStringTextBox.TabIndex = 0;
            this.connectionStringTextBox.Text = "Endpoint=sb://xxx.servicebus.windows.net/;SharedAccessKeyName=Queue-1;SharedAcces" +
    "sKey=hDSKCHzpaxqXyNUJZhEw81DBv2pVOlZPyqXq1Go5Iak=";
            // 
            // Form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.connectionStringTextBox);
            this.Controls.Add(this.connectionStatusLabel);
            this.Controls.Add(this.sendMessageButton);
            this.Controls.Add(this.connectButton);
            this.Controls.Add(this.messsageTextBox);
            this.Name = "Form";
            this.Text = "Queue Client";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox messsageTextBox;
        private System.Windows.Forms.Button connectButton;
        private System.Windows.Forms.Button sendMessageButton;
        private System.Windows.Forms.Label connectionStatusLabel;
        private System.Windows.Forms.TextBox connectionStringTextBox;
    }
}

