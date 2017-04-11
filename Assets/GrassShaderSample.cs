using UnityEngine;

public class GrassShaderSample : MonoBehaviour
{
    #region Field

    /// <summary>
    /// 草のシェーダを設定した Material.
    /// </summary>
    public Material grassShaderMaterial;

    /// <summary>
    /// 風の乱れ具合。
    /// </summary>
    public float tarburance = 0.1f;

    #endregion Field

    /// <summary>
    /// 更新時に呼び出されます。
    /// </summary>
    protected virtual void Update ()
    {
        this.grassShaderMaterial.SetFloat("_WavePower1", Mathf.PerlinNoise(0, Time.time) * this.tarburance);
        this.grassShaderMaterial.SetFloat("_WavePower2", Mathf.PerlinNoise(0, Time.time + 1) * this.tarburance);

        this.grassShaderMaterial.SetVector("_WaveDirection", new Vector4()
        {
            x = Mathf.PerlinNoise(0, Time.time) * this.tarburance,
            y = 0,
            z = Mathf.PerlinNoise(Time.time, 0) * this.tarburance,
            w = 1,
        });
    }
}