Logs = {}

-- General webhook configurations
Logs.Name = 'Champs de drogue' -- Name for the webhook
Logs.Image = 'https://edmondio.info/Edmondio_dev.png' -- Image for the webhook
Logs.Footer = 'https://edmondio.info/Edmondio_dev.png' -- Footer image for the webhook

Logs.Types = {
    farm = {
        enabled = true, -- Enable this log?
        webhook = 'https://discord.com/api/webhooks/1258473531516387399/5jN1vE_Ox6BdGuOfx7TfzsASjv5IeQdT5FOirMusGfrSzgkIYzUZ08GNuFrVItpNq1T-' -- Webhook link
    },
    enterfarm = {
        enabled = true,
        webhook = 'https://discord.com/api/webhooks/1258473531516387399/5jN1vE_Ox6BdGuOfx7TfzsASjv5IeQdT5FOirMusGfrSzgkIYzUZ08GNuFrVItpNq1T-'
    }
    ,
    resetfarm = {
        enabled = true,
        webhook = 'https://discord.com/api/webhooks/1272581522620289075/NaxO7ZjFDUqU-ffvmwxMiBAJXLqKPReMUXO1yON2ogf121s2a471NMWDrQTHCjnX9Iqa'
    }
}