# AnnotationEfficiency2D

This is the code repository for the paper:  
**How to Efficiently Annotate Images for Best-Performing Deep Learning-Based Segmentation Models: An Empirical Study with Weak and Noisy Annotations and Segment Anything Model**  
**DOI**: [10.1007/s10278-025-01408-7](https://doi.org/10.1007/s10278-025-01408-7)

This paper is an empirical study. We did not propose nay new algorithm in this study. We release all code used for running the experiment as a proof of efforts. For the MCG algorithm dependant by SDI, we downloaded the algorithm from the original MCG branch (in MATLAB) rather than make our own Python implementation. We selected an object's pseudo-mask to be the one whose bounding box yields that largest IoU with the bounding box of the ground truth segmenation mask. For the GrabCut, we used the OpenCV implementation.

## Citation

If you find our work helpful, please consider citing:

```bibtex
@article{zhang2025efficiently,
  title={How to Efficiently Annotate Images for Best-Performing Deep Learning-Based Segmentation Models: An Empirical Study with Weak and Noisy Annotations and Segment Anything Model},
  author={Zhang, Yixin and Zhao, Shen and Gu, Hanxue and Mazurowski, Maciej A},
  journal={Journal of Imaging Informatics in Medicine},
  pages={1--13},
  year={2025},
  publisher={Springer}
}
